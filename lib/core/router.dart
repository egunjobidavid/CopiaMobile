import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
import '../features/auth/presentation/auth_provider.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/dashboard/presentation/quick_actions_screen.dart';
import '../features/dashboard/presentation/more_screen.dart';
import '../features/dashboard/presentation/profile_screen.dart';
import '../features/products/presentation/product_search_screen.dart';
import '../features/products/presentation/product_scanner_screen.dart';
import '../features/products/presentation/product_detail_screen.dart';
import '../features/sales/presentation/order_list_screen.dart';
import '../features/sales/presentation/order_create_screen.dart';
import '../features/sales/presentation/order_detail_screen.dart';
import '../features/pos/presentation/pos_screen.dart';
import '../features/pos/presentation/pos_success_screen.dart';
import '../features/inventory/presentation/stock_view_screen.dart';
import '../features/inventory/presentation/stock_detail_screen.dart';
import '../features/inventory/presentation/stock_movement_screen.dart';
import '../features/inventory/presentation/goods_receipt_screen.dart';
import '../features/inventory/presentation/stock_take_screen.dart';
import '../features/inventory/presentation/stock_transfer_screen.dart';
import '../features/approvals/presentation/approvals_screen.dart';
import '../features/finance/presentation/expense_claims_screen.dart';
import '../features/staff/presentation/staff_modules_screen.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../features/maintenance/presentation/maintenance_screen.dart';
import '../features/maintenance/presentation/force_update_screen.dart';
import '../features/maintenance/presentation/maintenance_provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const _tabs = [
    _TabConfig(path: '/home', label: 'Home', icon: Icons.home_rounded),
    _TabConfig(path: '/sales', label: 'Sales', icon: Icons.receipt_long_rounded),
    _TabConfig(path: '/create', label: 'Create', icon: Icons.add_circle_rounded),
    _TabConfig(path: '/inventory', label: 'Stock', icon: Icons.inventory_2_rounded),
    _TabConfig(path: '/more', label: 'More', icon: Icons.more_horiz_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          border: Border(
            top: BorderSide(color: AppTheme.border, width: 0.5),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_tabs.length, (index) {
                final tab = _tabs[index];
                final isSelected = _currentIndex == index;
                final isCreate = index == 2;

                if (isCreate) {
                  return GestureDetector(
                    onTap: () {
                      setState(() => _currentIndex = index);
                      context.go(tab.path);
                    },
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  );
                }

                return GestureDetector(
                  onTap: () {
                    setState(() => _currentIndex = index);
                    context.go(tab.path);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 60,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primarySurface
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                          ),
                          child: Icon(
                            tab.icon,
                            color: isSelected
                                ? AppTheme.primary
                                : AppTheme.textTertiary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tab.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color:
                                isSelected ? AppTheme.primary : AppTheme.textTertiary,
                            fontFamily: 'Inter',
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabConfig {
  final String path;
  final String label;
  final IconData icon;

  const _TabConfig({
    required this.path,
    required this.label,
    required this.icon,
  });
}

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  redirect: (context, state) {
    final container = ProviderScope.containerOf(context);
    final authState = container.read(authStateProvider);

    // Still loading session — show nothing yet
    if (authState.isLoading) return null;

    // Check maintenance mode
    final maintenanceState = container.read(maintenanceProvider);
    final versionState = container.read(versionCheckProvider);

    final isMaintenanceRoute = state.matchedLocation == '/maintenance';
    final isUpdateRoute = state.matchedLocation == '/force-update';
    final isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/register';

    // Maintenance mode active — redirect to maintenance screen
    if (maintenanceState.enabled && !isMaintenanceRoute) {
      return '/maintenance';
    }

    // Force update required — redirect to update screen
    if (versionState.forceUpdate && !isUpdateRoute) {
      return '/force-update';
    }

    // Not authenticated and trying to access protected route
    if (!authState.isAuthenticated && !isAuthRoute) {
      return '/login';
    }

    // Authenticated and on login — redirect to home
    if (authState.isAuthenticated && isAuthRoute) {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/maintenance',
      builder: (context, state) {
        final c = ProviderScope.containerOf(context);
        final maintenanceState = c.read(maintenanceProvider);
        return MaintenanceScreen(
          message: maintenanceState.message.isNotEmpty
              ? maintenanceState.message
              : 'System is under maintenance. Please try again later.',
          onRetry: () {
            c.read(maintenanceProvider.notifier).check();
          },
        );
      },
    ),
    GoRoute(
      path: '/force-update',
      builder: (context, state) {
        final c = ProviderScope.containerOf(context);
        final versionState = c.read(versionCheckProvider);
        return ForceUpdateScreen(
          currentVersion: '1.0.0',
          latestVersion: versionState.version,
          changelog: versionState.changelog,
          downloadUrl: versionState.downloadUrl,
        );
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/sales',
          builder: (context, state) => const OrderListScreen(),
        ),
        GoRoute(
          path: '/create',
          builder: (context, state) => const QuickActionsScreen(),
        ),
        GoRoute(
          path: '/inventory',
          builder: (context, state) => const StockViewScreen(),
        ),
        GoRoute(
          path: '/more',
          builder: (context, state) => const MoreScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductSearchScreen(),
      routes: [
        GoRoute(
          path: 'scan',
          builder: (context, state) => const ProductScannerScreen(),
        ),
        GoRoute(
          path: ':id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return ProductDetailScreen(productId: id);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/sales/create',
      builder: (context, state) => const OrderCreateScreen(),
    ),
    GoRoute(
      path: '/sales/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return OrderDetailScreen(orderId: id);
      },
    ),
    GoRoute(
      path: '/inventory/movements',
      builder: (context, state) => const StockMovementScreen(),
    ),
    GoRoute(
      path: '/inventory/receive',
      builder: (context, state) => const GoodsReceiptScreen(),
    ),
    GoRoute(
      path: '/inventory/receive/:poId',
      builder: (context, state) {
        final poId = state.pathParameters['poId']!;
        return GoodsReceiptScreen(purchaseOrderId: poId);
      },
    ),
    GoRoute(
      path: '/inventory/stocktake',
      builder: (context, state) => const StockTakeScreen(),
    ),
    GoRoute(
      path: '/inventory/product/:productId',
      builder: (context, state) {
        final productId = state.pathParameters['productId']!;
        return StockDetailScreen(productId: productId);
      },
    ),
    GoRoute(
      path: '/pos',
      builder: (context, state) => const PosScreen(),
    ),
    GoRoute(
      path: '/pos/success',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return PosSuccessScreen(
          amount: extra['amount'] as double? ?? 0,
          paymentMethod: extra['paymentMethod'] as String? ?? 'Cash',
          itemCount: extra['itemCount'] as int? ?? 0,
        );
      },
    ),
    GoRoute(
      path: '/approvals',
      builder: (context, state) => const ApprovalsScreen(),
    ),
    GoRoute(
      path: '/expense-claims',
      builder: (context, state) => const ExpenseClaimsScreen(),
    ),
    GoRoute(
      path: '/stock-transfers',
      builder: (context, state) => const StockTransferScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/staff-modules',
      builder: (context, state) => const StaffModulesScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/',
      redirect: (context, state) => '/login',
    ),
  ],
);
