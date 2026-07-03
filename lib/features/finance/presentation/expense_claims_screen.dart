import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage.dart';
import '../../auth/presentation/auth_provider.dart';

class ExpenseClaim {
  final String id;
  final String category;
  final double amount;
  final String description;
  final DateTime expenseDate;
  final String status;
  final DateTime createdAt;

  ExpenseClaim({
    required this.id,
    required this.category,
    required this.amount,
    required this.description,
    required this.expenseDate,
    required this.status,
    required this.createdAt,
  });

  factory ExpenseClaim.fromJson(Map<String, dynamic> json) {
    return ExpenseClaim(
      id: json['id'].toString(),
      category: json['category'] ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '') ?? 0,
      description: json['description'] ?? '',
      expenseDate: DateTime.tryParse(json['expense_date'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'pending',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

final expenseClaimsProvider = FutureProvider<List<ExpenseClaim>>((ref) async {
  final storage = ref.watch(secureStorageProvider);
  final api = ApiClient(storage);
  final response = await api.get('/hr/expense-claims');
  final envelope = response.data as Map<String, dynamic>;
  final data = envelope['data'] as List? ?? [];
  return data.map((json) => ExpenseClaim.fromJson(json as Map<String, dynamic>)).toList();
});

class ExpenseClaimsScreen extends ConsumerStatefulWidget {
  const ExpenseClaimsScreen({super.key});

  @override
  ConsumerState<ExpenseClaimsScreen> createState() => _ExpenseClaimsScreenState();
}

class _ExpenseClaimsScreenState extends ConsumerState<ExpenseClaimsScreen> {
  @override
  Widget build(BuildContext context) {
    final claimsAsync = ref.watch(expenseClaimsProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add_rounded, size: 28),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    color: AppTheme.textPrimary,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Expense Claims',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: claimsAsync.when(
                loading: () => _buildLoading(),
                error: (e, _) => _buildError(),
                data: (claims) {
                  if (claims.isEmpty) {
                    return _buildEmpty();
                  }

                  final totalPending = claims
                      .where((c) => c.status == 'pending')
                      .fold<double>(0, (sum, c) => sum + c.amount);
                  final totalApproved = claims
                      .where((c) => c.status == 'approved')
                      .fold<double>(0, (sum, c) => sum + c.amount);
                  final totalAll = claims.fold<double>(0, (sum, c) => sum + c.amount);

                  return RefreshIndicator(
                    onRefresh: () => ref.refresh(expenseClaimsProvider.future),
                    color: AppTheme.primary,
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _SummaryCard(
                                    title: 'Pending',
                                    value: '₦${totalPending.toStringAsFixed(2)}',
                                    icon: Icons.schedule_rounded,
                                    color: AppTheme.warning,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _SummaryCard(
                                    title: 'Approved',
                                    value: '₦${totalApproved.toStringAsFixed(2)}',
                                    icon: Icons.check_circle_outline_rounded,
                                    color: AppTheme.success,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _SummaryCard(
                                    title: 'Total',
                                    value: '₦${totalAll.toStringAsFixed(2)}',
                                    icon: Icons.account_balance_wallet_outlined,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 20)),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          sliver: SliverList.separated(
                            itemCount: claims.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              return _ExpenseCard(claim: claims[index]);
                            },
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 100)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateDialog() {
    final categoryController = TextEditingController();
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'New Expense Claim',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(hintText: 'Category (e.g. Transport, Meals)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: 'Amount',
                  prefixText: '₦ ',
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(primary: AppTheme.primary),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setModalState(() => selectedDate = picked);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 20, color: AppTheme.textSecondary),
                      const SizedBox(width: 12),
                      Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(hintText: 'Description'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    final category = categoryController.text.trim();
                    final amount = double.tryParse(amountController.text.trim());
                    final description = descriptionController.text.trim();

                    if (category.isEmpty || amount == null || amount <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill in all required fields')),
                      );
                      return;
                    }

                    Navigator.pop(ctx);

                    try {
                      final storage = ref.read(secureStorageProvider);
                      final api = ApiClient(storage);
                      final authState = ref.read(authStateProvider);
                      final userId = authState.user?['id'] as String? ?? '';
                      await api.post('/hr/expense-claims', data: {
                        'employeeId': userId,
                        'category': category,
                        'amount': amount,
                        'description': description,
                        'expenseDate': selectedDate.toIso8601String(),
                      });
                      ref.invalidate(expenseClaimsProvider);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Expense claim created'),
                            backgroundColor: AppTheme.success,
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to create: $e'),
                            backgroundColor: AppTheme.error,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Submit Claim',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
        ),
        child: const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
      ),
    );
  }

  Widget _buildError() {
    return Center(
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
            'Failed to load expense claims',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: () => ref.refresh(expenseClaimsProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
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
              child: Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: AppTheme.primary.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No expense claims',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the + button to create your first expense claim',
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
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
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  final ExpenseClaim claim;

  const _ExpenseCard({required this.claim});

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'transport':
        return Icons.directions_car_rounded;
      case 'meals':
      case 'food':
        return Icons.restaurant_rounded;
      case 'accommodation':
        return Icons.hotel_rounded;
      case 'communication':
        return Icons.phone_rounded;
      case 'office supplies':
        return Icons.desktop_windows_rounded;
      default:
        return Icons.receipt_rounded;
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppTheme.success;
      case 'rejected':
        return AppTheme.error;
      default:
        return AppTheme.warning;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(claim.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _categoryIcon(claim.category),
                  color: AppTheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      claim.category,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(claim.expenseDate),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  claim.status[0].toUpperCase() + claim.status.substring(1),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          if (claim.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              claim.description,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '₦${claim.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
