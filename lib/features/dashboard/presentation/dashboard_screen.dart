import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../../core/theme.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../widgets/notification_badge.dart';
import '../../../core/notifications/notification_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  Map<String, dynamic>? _dashboardData;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final storage = ref.read(secureStorageProvider);
      final api = ApiClient(storage);
      final response = await api.get('/analytics/dashboard');
      final envelope = response.data as Map<String, dynamic>;
      final data = envelope['data'] as Map<String, dynamic>? ?? envelope;
      if (mounted) {
        setState(() {
          _dashboardData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
      return user['name'] as String? ?? user['firstName'] as String? ?? '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final lastNotification = ref.watch(lastNotificationProvider);
    final userName = _getUserName();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: RefreshIndicator(
        onRefresh: _loadDashboard,
        color: AppTheme.primary,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(lastNotification != null ? 1 : 0),
                      const SizedBox(height: 28),
                      _buildGreeting(userName),
                      const SizedBox(height: 24),
                      _buildKpiCards(),
                      const SizedBox(height: 28),
                      _buildQuickActions(),
                      const SizedBox(height: 28),
                      _buildRecentActivity(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
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
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: Text(
              'C',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Row(
          children: [
            NotificationBadgeIcon(
              count: notifCount,
              onTap: () => context.push('/notifications'),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: AppTheme.primary,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGreeting(String name) {
    final display = name.isNotEmpty ? '$name 👋' : '👋';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_getGreeting()},',
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          display,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCards() {
    if (_isLoading) {
      return Row(
        children: List.generate(
          3,
          (i) => Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < 2 ? 12 : 0),
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
        ),
      );
    }

    final revenue = _dashboardData?['totalRevenue'] ?? 0;
    final outstanding = _dashboardData?['outstanding'] ?? 0;
    final products = _dashboardData?['totalProducts'] ?? 0;

    return Row(
      children: [
        Expanded(
          child: _KpiCard(
            label: 'Revenue',
            value: _formatCurrency(revenue),
            icon: Icons.trending_up_rounded,
            color: AppTheme.primary,
            gradient: AppTheme.primaryGradient,
            trend: _dashboardData?['revenueTrend'],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _KpiCard(
            label: 'Outstanding',
            value: _formatCurrency(outstanding),
            icon: Icons.account_balance_wallet_rounded,
            color: AppTheme.secondary,
            gradient: AppTheme.coralGradient,
            trend: _dashboardData?['outstandingTrend'],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _KpiCard(
            label: 'Products',
            value: products.toString(),
            icon: Icons.inventory_2_rounded,
            color: AppTheme.accent,
            gradient: AppTheme.tealGradient,
          ),
        ),
      ],
    );
  }

  String _formatCurrency(dynamic value) {
    final amount = (value is num) ? value : 0;
    if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(1)}M';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(1)}K';
    return amount.toStringAsFixed(0);
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _QuickActionButton(
              icon: Icons.point_of_sale_rounded,
              label: 'POS',
              color: AppTheme.success,
              onTap: () => context.push('/pos'),
            ),
            _QuickActionButton(
              icon: Icons.add_shopping_cart_rounded,
              label: 'New Sale',
              color: AppTheme.primary,
              onTap: () => context.push('/sales/create'),
            ),
            _QuickActionButton(
              icon: Icons.receipt_long_rounded,
              label: 'New Order',
              color: AppTheme.secondary,
              onTap: () => context.push('/sales'),
            ),
            _QuickActionButton(
              icon: Icons.inventory_2_rounded,
              label: 'Products',
              color: AppTheme.accent,
              onTap: () => context.push('/products'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    final recentOrders = _dashboardData?['recentOrders'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/sales'),
              child: const Text(
                'See all',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_isLoading)
          ...List.generate(
            3,
            (i) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          )
        else if (recentOrders.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: AppTheme.cardDecoration,
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  size: 48,
                  color: AppTheme.textSecondary.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 12),
                const Text(
                  'No recent activity',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Your recent orders will appear here',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          )
        else
          ...recentOrders.take(5).map((order) => _ActivityTile(
                title: order['customerName'] ?? 'Walk-in Customer',
                subtitle: 'Order #${order['orderNumber'] ?? ''}',
                amount: _formatCurrency(order['totalAmount'] ?? 0),
                status: order['status'] ?? 'pending',
                time: order['createdAt'] ?? '',
              )),
      ],
    );
  }


}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Gradient gradient;
  final dynamic trend;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.gradient,
    this.trend,
  });

  @override
  Widget build(BuildContext context) {
    final trendValue = trend is num ? trend as num : null;
    final isUp = trendValue != null && trendValue > 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const Spacer(),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (trendValue != null) ...[
                const SizedBox(width: 4),
                Icon(
                  isUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                  size: 14,
                  color: isUp ? AppTheme.success : AppTheme.error,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final String status;
  final String time;

  const _ActivityTile({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.status,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = status.toLowerCase() == 'completed'
        ? AppTheme.success
        : status.toLowerCase() == 'cancelled'
            ? AppTheme.error
            : AppTheme.warning;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: AppTheme.cardDecoration,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.receipt_rounded,
              color: statusColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
