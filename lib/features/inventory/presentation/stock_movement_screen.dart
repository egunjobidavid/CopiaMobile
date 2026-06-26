import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';
import '../models/stock_movement.dart';
import 'inventory_provider.dart';

class StockMovementScreen extends ConsumerStatefulWidget {
  const StockMovementScreen({super.key});

  @override
  ConsumerState<StockMovementScreen> createState() => _StockMovementScreenState();
}

class _StockMovementScreenState extends ConsumerState<StockMovementScreen> {
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _filters = [
    {'label': 'All', 'color': AppTheme.primary},
    {'label': 'IN', 'color': AppTheme.success},
    {'label': 'OUT', 'color': AppTheme.error},
    {'label': 'ADJ', 'color': AppTheme.warning},
  ];

  @override
  Widget build(BuildContext context) {
    final movementsAsync = ref.watch(stockMovementsProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Stock Movements'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter tabs
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter['label'];
                final color = filter['color'] as Color;

                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = filter['label']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? color : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? color : AppTheme.dividerColor,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        filter['label'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : color,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Movements list
          Expanded(
            child: movementsAsync.when(
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
                      'Failed to load movements',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              data: (movements) {
                final filtered = movements.where((m) {
                  if (_selectedFilter == 'All') return true;
                  if (_selectedFilter == 'IN' && m.isInbound) return true;
                  if (_selectedFilter == 'OUT' && m.isOutbound) return true;
                  if (_selectedFilter == 'ADJ' && !m.isInbound && !m.isOutbound) return true;
                  return false;
                }).toList();

                if (filtered.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () => ref.refresh(stockMovementsProvider.future),
                  color: AppTheme.primary,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final m = filtered[index];
                      return _MovementCard(movement: m);
                    },
                  ),
                );
              },
            ),
          ),
        ],
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
              child: Icon(Icons.swap_vert_rounded, size: 64, color: AppTheme.primary.withValues(alpha: 0.4)),
            ),
            const SizedBox(height: 24),
            const Text(
              'No movements yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Stock movements will appear here',
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
      itemCount: 6,
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
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.dividerColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppTheme.dividerColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 12,
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.dividerColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 16,
                  width: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.dividerColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 12,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.dividerColor,
                    borderRadius: BorderRadius.circular(4),
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

class _MovementCard extends StatelessWidget {
  final StockMovement movement;

  const _MovementCard({required this.movement});

  @override
  Widget build(BuildContext context) {
    final isInbound = movement.isInbound;
    final isAdj = !movement.isInbound && !movement.isOutbound;
    final typeColor = isAdj
        ? AppTheme.warning
        : isInbound
            ? AppTheme.success
            : AppTheme.error;

    final typeIcon = isAdj
        ? Icons.tune_rounded
        : isInbound
            ? Icons.arrow_downward_rounded
            : Icons.arrow_upward_rounded;

    final typeLabel = isAdj
        ? 'ADJ'
        : isInbound
            ? 'IN'
            : 'OUT';

    return Container(
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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(typeIcon, color: typeColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movement.productName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: typeColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        typeLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: typeColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      movement.reference ?? '',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  movement.createdAt.length > 10
                      ? movement.createdAt.substring(0, 10)
                      : movement.createdAt,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isInbound ? '+' : isAdj ? '' : '-'}${movement.quantity.toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: typeColor,
                ),
              ),
              const SizedBox(height: 4),
              if (movement.warehouseName.isNotEmpty)
                Text(
                  movement.warehouseName,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
