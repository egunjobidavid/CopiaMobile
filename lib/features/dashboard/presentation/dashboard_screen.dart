import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../../core/theme.dart';
import '../../../core/network/api_client.dart';
import '../../../widgets/kpi_card.dart';
import '../../../widgets/action_widgets.dart';
import '../../../widgets/status_badge.dart';
import '../../../widgets/shimmer_skeleton.dart';
import '../../../widgets/empty_state.dart';
import '../../../core/notifications/notification_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  Map<String, dynamic>? _dashboardData;
  bool _kpiLoaded = false;
  bool _activityLoaded = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadKPIs();
  }

  Future<void> _loadKPIs() async {
    try {
      final api = ref.read(apiClientProvider);
      final response = await api.get('/analytics/dashboard');
      final data = extractOne(response.data) ?? <String, dynamic>{};
      if (mounted) {
        setState(() {
          _dashboardData = data;
          _kpiLoaded = true;
        });
        // Load activity after KPIs
        _loadActivity();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _kpiLoaded = true;
        });
      }
    }
  }

  Future<void> _loadActivity() async {
    // Activity is already part of the dashboard response
    if (mounted) {
      setState(() => _activityLoaded = true);
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _getUserName() {
    final user = ref.read(authStateProvider).user;
    if (user != null) {
      return user['fullName'] as String? ?? user['name'] as String? ?? '';
    }
    return '';
  }

  String _formatCurrency(dynamic value) {
    final amount = double.tryParse(value?.toString() ?? '') ?? 0;
    if (amount >= 1000000) return '₦${(amount / 1000000).toStringAsFixed(1)}M';
    if (amount >= 1000) return '₦${(amount / 1000).toStringAsFixed(1)}K';
    return '₦${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final userName = _getUserName();
    final lastNotification = ref.watch(lastNotificationProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _kpiLoaded = false;
            _activityLoaded = false;
            _error = null;
          });
          await _loadKPIs();
        },
        color: AppTheme.primary,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(lastNotification != null ? 1 : 0),
                      const SizedBox(height: 24),
                      _buildGreeting(userName),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // KPI Cards — progressive load
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: !_kpiLoaded
                    ? Row(
                        children: [
                          Expanded(child: ShimmerSkeleton.kpiCard()),
                          const SizedBox(width: 12),
                          Expanded(child: ShimmerSkeleton.kpiCard()),
                        ],
                      )
                    : _error != null
                        ? _buildErrorState()
                        : _buildKpiSection(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 28)),

            // Quick Actions — static, no loading
            SliverToBoxAdapter(
              child: _buildQuickActions(),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 28)),

            // Recent Activity — progressive load
            SliverToBoxAdapter(
              child: !_activityLoaded
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: List.generate(3, (_) => const _ActivitySkeletonTile()),
                      ),
                    )
                  : _buildRecentActivity(),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int notifCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
          ),
          child: const Center(
            child: Text(
              'C',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => context.push('/notifications'),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDim,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.notifications_outlined,
                      color: AppTheme.textSecondary,
                      size: 20,
                    ),
                    if (notifCount > 0)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => context.push('/profile'),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primarySurface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: AppTheme.primary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGreeting(String name) {
    final display = name.isNotEmpty ? name : '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_getGreeting()},',
          style: const TextStyle(
            fontSize: 15,
            color: AppTheme.textSecondary,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          display.isNotEmpty ? '$display 👋' : '👋',
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
            letterSpacing: -0.5,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildKpiSection() {
    final revenue = _dashboardData?['revenue'] ?? 0;
    final outstanding = _dashboardData?['outstandingInvoices'] ?? 0;

    return Row(
      children: [
        Expanded(
          child: KpiCard(
            label: 'Revenue',
            value: _formatCurrency(revenue),
            icon: Icons.trending_up_rounded,
            gradient: AppTheme.primaryGradient,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: KpiCard(
            label: 'Outstanding',
            value: _formatCurrency(outstanding),
            icon: Icons.account_balance_wallet_rounded,
            gradient: AppTheme.warmGradient,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return EmptyState(
      icon: Icons.cloud_off_rounded,
      title: 'Unable to load dashboard',
      message: 'Check your connection and try again',
      actionLabel: 'Retry',
      onAction: () {
        setState(() {
          _kpiLoaded = false;
          _error = null;
        });
        _loadKPIs();
      },
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Quick Actions',
            icon: Icons.flash_on_rounded,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              QuickActionButton(
                icon: Icons.point_of_sale_rounded,
                label: 'POS',
                color: AppTheme.success,
                onTap: () => context.push('/pos'),
              ),
              QuickActionButton(
                icon: Icons.add_shopping_cart_rounded,
                label: 'New Sale',
                color: AppTheme.primary,
                onTap: () => context.push('/sales/create'),
              ),
              QuickActionButton(
                icon: Icons.receipt_long_rounded,
                label: 'Orders',
                color: AppTheme.accent,
                onTap: () => context.push('/sales'),
              ),
              QuickActionButton(
                icon: Icons.inventory_2_rounded,
                label: 'Products',
                color: AppTheme.secondary,
                onTap: () => context.push('/products'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    final recentOrders = _dashboardData?['recentOrders'] as List<dynamic>? ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Recent Activity',
            icon: Icons.access_time_rounded,
            actionLabel: 'See all',
            onAction: () => context.push('/sales'),
          ),
          const SizedBox(height: 12),
          if (recentOrders.isEmpty)
            const InlineEmptyState(
              icon: Icons.receipt_long_rounded,
              message: 'No recent activity yet.\nYour orders will appear here.',
            )
          else
            ...recentOrders.take(5).map((order) => ActivityTile(
                  title: order['customerName'] ?? 'Walk-in Customer',
                  subtitle: 'Order #${order['orderNumber'] ?? ''}',
                  amount: _formatCurrency(order['totalAmount'] ?? 0),
                  status: order['status'] ?? 'pending',
                  time: order['createdAt'] ?? '',
                )),
        ],
      ),
    );
  }
}

/// Skeleton tile for activity loading state.
class _ActivitySkeletonTile extends StatelessWidget {
  const _ActivitySkeletonTile();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          ShimmerSkeleton.circle(size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerSkeleton(width: 140, height: 14),
                const SizedBox(height: 6),
                ShimmerSkeleton(width: 100, height: 12),
              ],
            ),
          ),
          ShimmerSkeleton(width: 60, height: 14),
        ],
      ),
    );
  }
}
