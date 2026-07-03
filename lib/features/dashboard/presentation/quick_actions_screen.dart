import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme.dart';

class QuickActionsScreen extends StatelessWidget {
  const QuickActionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Create, manage, and track everything',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _buildSection(
                      'Create',
                      [
                        const _ActionItem(
                          icon: Icons.receipt_long_rounded,
                          label: 'New Invoice',
                          description: 'Bill your customer',
                          color: AppTheme.primary,
                          gradient: AppTheme.primaryGradient,
                          route: '/sales/create',
                        ),
                        const _ActionItem(
                          icon: Icons.request_quote_rounded,
                          label: 'New Quote',
                          description: 'Send a price estimate',
                          color: AppTheme.accent,
                          gradient: AppTheme.secondaryGradient,
                          route: '/sales/create',
                        ),
                        const _ActionItem(
                          icon: Icons.shopping_cart_rounded,
                          label: 'New Order',
                          description: 'Create a sales order',
                          color: AppTheme.secondary,
                          gradient: AppTheme.warmGradient,
                          route: '/sales/create',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      'Inventory',
                      [
                        const _ActionItem(
                          icon: Icons.inventory_2_rounded,
                          label: 'Stock Take',
                          description: 'Count physical stock',
                          color: Color(0xFFF59E0B),
                          gradient: LinearGradient(
                            colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                          ),
                          route: '/inventory/stocktake',
                        ),
                        const _ActionItem(
                          icon: Icons.qr_code_scanner_rounded,
                          label: 'Scan Product',
                          description: 'Find by barcode',
                          color: Color(0xFF8B5CF6),
                          gradient: LinearGradient(
                            colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
                          ),
                          route: '/products/scan',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      'Finance',
                      [
                        const _ActionItem(
                          icon: Icons.payments_rounded,
                          label: 'Record Expense',
                          description: 'Track business spending',
                          color: Color(0xFFEF4444),
                          gradient: LinearGradient(
                            colors: [Color(0xFFEF4444), Color(0xFFF87171)],
                          ),
                          route: '/expense-claims',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      'People',
                      [
                        _ActionItem(
                          icon: Icons.person_add_rounded,
                          label: 'Add Customer',
                          description: 'New customer profile',
                          color: Color(0xFF10B981),
                          gradient: LinearGradient(
                            colors: [Color(0xFF10B981), Color(0xFF34D399)],
                          ),
                          onTap: (ctx) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(
                                content: Text('Customer creation coming soon'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      'Insights',
                      [
                        const _ActionItem(
                          icon: Icons.bar_chart_rounded,
                          label: 'View Reports',
                          description: 'Sales & performance data',
                          color: Color(0xFF3B82F6),
                          gradient: LinearGradient(
                            colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                          ),
                          route: '/home',
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<_ActionItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.55,
          children: items.map((item) => _ActionCard(item: item)).toList(),
        ),
      ],
    );
  }

}

class _ActionItem {
  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final Gradient gradient;
  final String? route;
  final void Function(BuildContext)? onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.gradient,
    this.route,
    this.onTap,
  });
}

class _ActionCard extends StatelessWidget {
  final _ActionItem item;

  const _ActionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.onTap != null) {
          item.onTap!(context);
        } else if (item.route != null) {
          context.push(item.route!);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.border.withValues(alpha: 0.5), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: item.color.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: item.gradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: Colors.white, size: 20),
            ),
            const Spacer(),
            Text(
              item.label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.description,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
