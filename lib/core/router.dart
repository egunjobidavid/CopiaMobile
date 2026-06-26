import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme.dart';
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
    _TabConfig(
        path: '/sales', label: 'Sales', icon: Icons.receipt_long_rounded),
    _TabConfig(
        path: '/create', label: 'Create', icon: Icons.add_circle_rounded),
    _TabConfig(
        path: '/inventory',
        label: 'Stock',
        icon: Icons.inventory_2_rounded),
    _TabConfig(path: '/more', label: 'More', icon: Icons.more_horiz_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 28,
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
                    width: 64,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primary.withValues(alpha: 0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            tab.icon,
                            color: isSelected
                                ? AppTheme.primary
                                : AppTheme.textLight,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tab.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                            color:
                                isSelected ? AppTheme.primary : AppTheme.textLight,
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
  routes: [
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
    // Delivery routes — disabled until backend supports /deliveries
    // GoRoute(
    //   path: '/deliveries',
    //   builder: (context, state) => const DeliveryListScreen(),
    //   routes: [
    //     GoRoute(
    //       path: ':id',
    //       builder: (context, state) {
    //         final id = state.pathParameters['id']!;
    //         return DeliveryDetailScreen(deliveryId: id);
    //       },
    //     ),
    //     GoRoute(
    //       path: ':id/confirm',
    //       builder: (context, state) {
    //         final id = state.pathParameters['id']!;
    //         return DeliveryConfirmScreen(deliveryId: id);
    //       },
    //     ),
    //   ],
    // ),
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
