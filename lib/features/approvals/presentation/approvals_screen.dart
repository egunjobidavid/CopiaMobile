import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage.dart';

class ApprovalItem {
  final String id;
  final String type;
  final String title;
  final String description;
  final String requester;
  final String? department;
  final double? amount;
  final DateTime date;
  final String status;

  ApprovalItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.requester,
    this.department,
    this.amount,
    required this.date,
    required this.status,
  });

  factory ApprovalItem.fromJson(Map<String, dynamic> json) {
    return ApprovalItem(
      id: json['id'].toString(),
      type: json['entityType'] ?? json['entity_type'] ?? json['type'] ?? '',
      title: json['title'] ?? json['reason'] ?? '',
      description: json['description'] ?? json['reason'] ?? '',
      requester: json['requester'] ?? json['requestorId'] ?? json['requestor_id'] ?? '',
      department: json['department'],
      amount: json['amount'] != null ? double.tryParse(json['amount'].toString()) : null,
      date: DateTime.tryParse(json['createdAt'] ?? json['created_at'] ?? json['date'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'pending',
    );
  }
}

final pendingApprovalsProvider = FutureProvider<List<ApprovalItem>>((ref) async {
  try {
    final api = ref.watch(apiClientProvider);
    final response = await api.get('/approvals?status=pending');
    final items = extractList(response.data);
    return items.map((json) => ApprovalItem.fromJson(json)).toList();
  } catch (e) {
    return [];
  }
});

class ApprovalsScreen extends ConsumerStatefulWidget {
  const ApprovalsScreen({super.key});

  @override
  ConsumerState<ApprovalsScreen> createState() => _ApprovalsScreenState();
}

class _ApprovalsScreenState extends ConsumerState<ApprovalsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _tabs = [
    'All',
    'Leave',
    'Expenses',
    'POs',
    'Credit Memos',
    'Journals',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _typeFilter(int index) {
    switch (index) {
      case 1:
        return 'leave';
      case 2:
        return 'expense';
      case 3:
        return 'purchase_order';
      case 4:
        return 'credit_memo';
      case 5:
        return 'journal';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final approvalsAsync = ref.watch(pendingApprovalsProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
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
                    'Approvals',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  approvalsAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (approvals) => approvals.isNotEmpty
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.secondary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${approvals.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Colors.white,
                unselectedLabelColor: AppTheme.textSecondary,
                labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                unselectedLabelStyle: const TextStyle(fontSize: 13),
                indicator: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                tabs: _tabs.map((t) => Tab(text: t)).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: approvalsAsync.when(
                loading: () => _buildLoading(),
                error: (e, _) => _buildError(e.toString()),
                data: (approvals) {
                  if (approvals.isEmpty) {
                    return _buildEmpty();
                  }

                  return TabBarView(
                    controller: _tabController,
                    children: List.generate(_tabs.length, (tabIndex) {
                      final filter = _typeFilter(tabIndex);
                      final filtered = filter.isEmpty
                          ? approvals
                          : approvals.where((a) => a.type == filter).toList();

                      if (filtered.isEmpty) {
                        return _buildEmpty();
                      }

                      return RefreshIndicator(
                        onRefresh: () => ref.refresh(pendingApprovalsProvider.future),
                        color: AppTheme.primary,
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = filtered[index];
                            return _ApprovalCard(
                              item: item,
                              onApprove: () => _handleApprove(item),
                              onReject: () => _handleReject(item),
                            );
                          },
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleApprove(ApprovalItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Approve'),
        content: Text('Approve "${item.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.success),
            child: const Text('Approve'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final api = ref.read(apiClientProvider);
        await api.patch('/approvals/${item.id}/vote', data: {'decision': 'approved'});
        ref.invalidate(pendingApprovalsProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${item.title} approved'),
              backgroundColor: AppTheme.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to approve: $e'),
              backgroundColor: AppTheme.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleReject(ApprovalItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject'),
        content: Text('Reject "${item.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.error),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final api = ref.read(apiClientProvider);
        await api.patch('/approvals/${item.id}/vote', data: {'decision': 'rejected'});
        ref.invalidate(pendingApprovalsProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${item.title} rejected'),
              backgroundColor: AppTheme.error,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to reject: $e'),
              backgroundColor: AppTheme.error,
            ),
          );
        }
      }
    }
  }

  Widget _buildLoading() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => Container(
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
        ),
        child: const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
      ),
    );
  }

  Widget _buildError(String message) {
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
            'Failed to load approvals',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: () => ref.refresh(pendingApprovalsProvider),
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
                color: AppTheme.success.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                size: 64,
                color: AppTheme.success.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'All caught up!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'No pending approvals at the moment',
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

class _ApprovalCard extends StatelessWidget {
  final ApprovalItem item;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _ApprovalCard({
    required this.item,
    required this.onApprove,
    required this.onReject,
  });

  IconData _typeIcon(String type) {
    switch (type) {
      case 'leave':
        return Icons.event_busy_rounded;
      case 'expense':
        return Icons.receipt_long_rounded;
      case 'purchase_order':
        return Icons.shopping_cart_outlined;
      case 'credit_memo':
        return Icons.discount_rounded;
      case 'journal':
        return Icons.book_outlined;
      default:
        return Icons.article_outlined;
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'leave':
        return AppTheme.warning;
      case 'expense':
        return AppTheme.secondary;
      case 'purchase_order':
        return AppTheme.primary;
      case 'credit_memo':
        return AppTheme.accent;
      case 'journal':
        return AppTheme.textSecondary;
      default:
        return AppTheme.primary;
    }
  }

  String _typeBadgeLabel(String type) {
    switch (type) {
      case 'leave':
        return 'Leave';
      case 'expense':
        return 'Expense';
      case 'purchase_order':
        return 'PO';
      case 'credit_memo':
        return 'Credit Memo';
      case 'journal':
        return 'Journal';
      default:
        return type;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(item.type);

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
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_typeIcon(item.type), color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.requester}${item.department != null ? ' · ${item.department}' : ''}',
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
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _typeBadgeLabel(item.type),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          if (item.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              item.description,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (item.amount != null) ...[
                Text(
                  '₦${item.amount!.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
              ] else
                const Spacer(),
              Text(
                _formatDate(item.date),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.error,
                      side: const BorderSide(color: AppTheme.error, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Reject',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: ElevatedButton(
                    onPressed: onApprove,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.success,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Approve',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
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
