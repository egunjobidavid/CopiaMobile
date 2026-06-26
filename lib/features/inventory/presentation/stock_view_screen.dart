import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';
import '../models/stock_balance.dart';
import 'inventory_provider.dart';
import 'stock_detail_screen.dart';
import 'stock_movement_screen.dart';

class StockViewScreen extends ConsumerStatefulWidget {
  const StockViewScreen({super.key});

  @override
  ConsumerState<StockViewScreen> createState() => _StockViewScreenState();
}

class _StockViewScreenState extends ConsumerState<StockViewScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final balancesAsync = ref.watch(stockBalancesProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Inventory',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Stock levels and movements',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const StockMovementScreen()),
                        );
                      },
                      icon: const Icon(Icons.history_rounded),
                      tooltip: 'View Movements',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Search inventory...',
                    prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textSecondary),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, color: AppTheme.textSecondary),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  onChanged: (value) => setState(() => _query = value.trim()),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Stock list
            Expanded(
              child: balancesAsync.when(
                loading: () => _buildShimmerList(),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppTheme.error.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.error_outline_rounded, size: 48, color: AppTheme.error),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Failed to load stock',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FilledButton.tonal(
                        onPressed: () => ref.refresh(stockBalancesProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
                data: (balances) {
                  final grouped = <String, List<StockBalance>>{};
                  for (final b in balances) {
                    grouped.putIfAbsent(b.productId, () => []);
                    grouped[b.productId]!.add(b);
                  }

                  final filtered = grouped.entries.where((entry) {
                    if (_query.isEmpty) return true;
                    final name = entry.value.first.productName.toLowerCase();
                    final sku = entry.value.first.sku.toLowerCase();
                    return name.contains(_query.toLowerCase()) || sku.contains(_query.toLowerCase());
                  }).toList();

                  if (filtered.isEmpty) {
                    return _buildEmptyState();
                  }

                  // Summary stats
                  final totalItems = filtered.length;
                  final totalValue = filtered.fold<double>(0, (sum, entry) {
                    return sum + entry.value.fold<double>(0, (s, b) => s + b.availableQuantity);
                  });
                  final lowStockCount = filtered.where((entry) {
                    final total = entry.value.fold<double>(0, (s, b) => s + b.availableQuantity);
                    return total <= 5 && total > 0;
                  }).length;

                  return Column(
                    children: [
                      // Summary cards
                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          children: [
                            _SummaryCard(
                              title: 'Total Items',
                              value: totalItems.toString(),
                              icon: Icons.inventory_2_outlined,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: 12),
                            _SummaryCard(
                              title: 'In Stock',
                              value: totalValue.toStringAsFixed(0),
                              icon: Icons.check_circle_outline_rounded,
                              color: AppTheme.success,
                            ),
                            const SizedBox(width: 12),
                            _SummaryCard(
                              title: 'Low Stock',
                              value: lowStockCount.toString(),
                              icon: Icons.warning_amber_rounded,
                              color: AppTheme.warning,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Stock list
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () => ref.refresh(stockBalancesProvider.future),
                          color: AppTheme.primary,
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final entry = filtered[index];
                              final productName = entry.value.first.productName;
                              final sku = entry.value.first.sku;
                              final totalAvailable = entry.value.fold<double>(0, (sum, b) => sum + b.availableQuantity);

                              return _StockCard(
                                productName: productName,
                                sku: sku,
                                quantity: totalAvailable,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => StockDetailScreen(productId: entry.key),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.inventory_2_outlined, size: 64, color: AppTheme.primary.withValues(alpha: 0.4)),
            ),
            const SizedBox(height: 24),
            const Text(
              'No stock balances',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Stock data will appear here once products are added',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, __) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.dividerColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppTheme.dividerColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 12,
                    width: 70,
                    decoration: BoxDecoration(
                      color: AppTheme.dividerColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 60,
              height: 28,
              decoration: BoxDecoration(
                color: AppTheme.dividerColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StockCard extends StatelessWidget {
  final String productName;
  final String sku;
  final double quantity;
  final VoidCallback onTap;

  const _StockCard({
    required this.productName,
    required this.sku,
    required this.quantity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLow = quantity <= 5 && quantity > 0;
    final isOut = quantity <= 0;
    final stockColor = isOut
        ? AppTheme.error
        : isLow
            ? AppTheme.warning
            : AppTheme.success;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: stockColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isOut
                    ? Icons.error_outline_rounded
                    : isLow
                        ? Icons.warning_amber_rounded
                        : Icons.check_circle_outline_rounded,
                color: stockColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'SKU: $sku',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Stock bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (quantity / 100).clamp(0.0, 1.0),
                      backgroundColor: AppTheme.dividerColor,
                      valueColor: AlwaysStoppedAnimation<Color>(stockColor),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  quantity.toStringAsFixed(0),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: stockColor,
                  ),
                ),
                const Text(
                  'units',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
