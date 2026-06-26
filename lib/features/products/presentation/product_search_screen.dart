import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';
import '../models/product.dart';
import 'product_provider.dart';
import 'product_detail_screen.dart';

class ProductSearchScreen extends ConsumerStatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  ConsumerState<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends ConsumerState<ProductSearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _categories = [
    {'label': 'All', 'icon': Icons.grid_view_rounded},
    {'label': 'Raw Material', 'icon': Icons.inventory_2_outlined},
    {'label': 'Finished Good', 'icon': Icons.done_all_rounded},
    {'label': 'Service', 'icon': Icons.design_services_rounded},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> _filterByCategory(List<Product> products) {
    if (_selectedCategory == 'All') return products;
    final typeMap = {
      'Raw Material': 'raw_material',
      'Finished Good': 'finished_good',
      'Service': 'service',
    };
    final type = typeMap[_selectedCategory];
    if (type == null) return products;
    return products.where((p) => p.productType == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productSearchProvider(_query));

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                'Products',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Text(
                'Browse and manage your product catalog',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),

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
                    hintText: 'Search by name or SKU...',
                    prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textSecondary),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_query.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear_rounded, color: AppTheme.textSecondary),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                          ),
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.qr_code_scanner_rounded, color: AppTheme.primary),
                            onPressed: () {
                              Navigator.pushNamed(context, '/products/scan');
                            },
                          ),
                        ),
                      ],
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) => setState(() => _query = value.trim()),
                  onChanged: (value) {
                    if (value.length >= 2) {
                      setState(() => _query = value.trim());
                    } else if (_query.isNotEmpty) {
                      setState(() => _query = '');
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category chips
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat['label'];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat['label']),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primary : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppTheme.primary : AppTheme.dividerColor,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            cat['icon'],
                            size: 16,
                            color: isSelected ? Colors.white : AppTheme.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            cat['label'],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Results
            Expanded(
              child: productsAsync.when(
                loading: () => _buildShimmerGrid(),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.error.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.error_outline_rounded, size: 48, color: AppTheme.error),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Failed to load products',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => setState(() => _query = _query),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
                data: (products) {
                  final filtered = _filterByCategory(products);
                  if (filtered.isEmpty && _query.isEmpty) {
                    return _buildEmptyState(
                      icon: Icons.search_rounded,
                      title: 'Start searching',
                      subtitle: 'Type a product name or SKU to find items',
                    );
                  }
                  if (filtered.isEmpty) {
                    return _buildEmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: 'No products found',
                      subtitle: 'Try a different search term or category',
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => setState(() => _query = _query),
                    color: AppTheme.primary,
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final product = filtered[index];
                        return _ProductCard(
                          product: product,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailScreen(productId: product.id),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            // TODO: Navigate to add product
          },
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add Product'),
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
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
              child: Icon(icon, size: 64, color: AppTheme.primary.withValues(alpha: 0.4)),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppTheme.dividerColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14,
                      width: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.dividerColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 10,
                      width: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.dividerColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 14,
                      width: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.dividerColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  IconData _getProductIcon() {
    switch (product.productType) {
      case 'raw_material':
        return Icons.inventory_2_outlined;
      case 'service':
        return Icons.design_services_rounded;
      default:
        return Icons.done_all_rounded;
    }
  }

  Color _getProductColor() {
    switch (product.productType) {
      case 'raw_material':
        return AppTheme.warning;
      case 'service':
        return AppTheme.accent;
      default:
        return AppTheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isInStock = product.stockQuantity > 5;
    final isLow = product.stockQuantity > 0 && product.stockQuantity <= 5;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _getProductColor().withValues(alpha: 0.08),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getProductColor().withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getProductIcon(),
                      size: 32,
                      color: _getProductColor(),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.sku,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₦${product.unitPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isInStock
                                ? AppTheme.success.withValues(alpha: 0.1)
                                : isLow
                                    ? AppTheme.warning.withValues(alpha: 0.1)
                                    : AppTheme.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isInStock
                                ? 'In Stock'
                                : isLow
                                    ? 'Low'
                                    : 'Out',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isInStock
                                  ? AppTheme.success
                                  : isLow
                                      ? AppTheme.warning
                                      : AppTheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
