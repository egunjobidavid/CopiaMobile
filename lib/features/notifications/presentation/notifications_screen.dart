import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool read;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.read,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'info',
      read: json['read'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

final notificationsPageProvider =
    StateNotifierProvider<NotificationsPageNotifier, AsyncValue<List<NotificationItem>>>((ref) {
  return NotificationsPageNotifier(ref)..loadFirstPage();
});

class NotificationsPageNotifier extends StateNotifier<AsyncValue<List<NotificationItem>>> {
  final Ref _ref;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoadingMore = false;
  bool get canLoadMore => _currentPage < _totalPages && !_isLoadingMore;
  int get totalPages => _totalPages;

  NotificationsPageNotifier(this._ref) : super(const AsyncValue.loading());

  ApiClient _api() {
    final storage = _ref.read(secureStorageProvider);
    return ApiClient(storage);
  }

  Future<void> loadFirstPage() async {
    state = const AsyncValue.loading();
    try {
      _currentPage = 1;
      final result = await _fetchPage(1);
      _totalPages = result['totalPages'] ?? 1;
      state = AsyncValue.data(result['items'] as List<NotificationItem>);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadNextPage() async {
    if (_isLoadingMore || _currentPage >= _totalPages) return;
    _isLoadingMore = true;
    try {
      _currentPage++;
      final result = await _fetchPage(_currentPage);
      _totalPages = result['totalPages'] ?? _totalPages;
      final existing = state.valueOrNull ?? [];
      state = AsyncValue.data([...existing, ...result['items'] as List<NotificationItem>]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<Map<String, dynamic>> _fetchPage(int page) async {
    final api = _api();
    final response = await api.get('/notifications', queryParameters: {'page': page});
    final raw = response.data;
    final data = extractList(raw);
    final totalPages = (raw is Map && raw['totalPages'] != null)
        ? (raw['totalPages'] as num).toInt()
        : 1;
    final items = data
        .map((json) => NotificationItem.fromJson(json))
        .toList();
    return {
      'items': items,
      'totalPages': totalPages,
    };
  }

  Future<void> markAsRead(String id) async {
    try {
      final api = _api();
      await api.patch('/notifications/$id/read');
      final current = state.valueOrNull ?? [];
      state = AsyncValue.data([
        for (final n in current)
          if (n.id == id) NotificationItem(id: n.id, title: n.title, message: n.message, type: n.type, read: true, createdAt: n.createdAt) else n,
      ]);
      _ref.invalidate(unreadCountProvider);
    } catch (_) {}
  }
}

final unreadCountProvider = FutureProvider<int>((ref) async {
  final storage = ref.watch(secureStorageProvider);
  final api = ApiClient(storage);
  final response = await api.get('/notifications/unread-count');
  final envelope = response.data as Map<String, dynamic>;
  return (envelope['count'] as num?)?.toInt() ?? 0;
});

String _timeAgo(DateTime dt) {
  final diff = DateTime.now().difference(dt);
  if (diff.inSeconds < 60) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
  return '${(diff.inDays / 30).floor()}mo ago';
}

IconData _iconForType(String type) {
  switch (type) {
    case 'order':
      return Icons.receipt_long_rounded;
    case 'stock':
      return Icons.inventory_2_rounded;
    case 'approval':
      return Icons.check_circle_outline_rounded;
    case 'expense':
      return Icons.account_balance_wallet_outlined;
    case 'system':
      return Icons.info_outline_rounded;
    default:
      return Icons.notifications_none_rounded;
  }
}

Color _colorForType(String type) {
  switch (type) {
    case 'order':
      return AppTheme.primary;
    case 'stock':
      return AppTheme.accent;
    case 'approval':
      return AppTheme.success;
    case 'expense':
      return AppTheme.warning;
    case 'system':
      return AppTheme.textSecondary;
    default:
      return AppTheme.primary;
  }
}

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(notificationsPageProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsPageProvider);
    final unreadAsync = ref.watch(unreadCountProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Row(
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  unreadAsync.when(
                    data: (count) => count > 0
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.secondary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$count unread',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.secondary,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: notificationsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline_rounded, size: 48, color: AppTheme.error.withValues(alpha: 0.6)),
                      const SizedBox(height: 12),
                      Text('Failed to load notifications', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => ref.read(notificationsPageProvider.notifier).loadFirstPage(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
                data: (notifications) {
                  if (notifications.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.notifications_none_rounded, size: 72, color: AppTheme.textLight.withValues(alpha: 0.5)),
                          const SizedBox(height: 16),
                          const Text(
                            'No notifications yet',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'You\'ll see updates about orders, stock, and approvals here.',
                            style: TextStyle(fontSize: 13, color: AppTheme.textLight),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: AppTheme.primary,
                    onRefresh: () => ref.read(notificationsPageProvider.notifier).loadFirstPage(),
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: notifications.length + (ref.read(notificationsPageProvider.notifier).canLoadMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == notifications.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primary)),
                          );
                        }

                        final notification = notifications[index];
                        return _NotificationTile(
                          notification: notification,
                          onTap: () {
                            if (!notification.read) {
                              ref.read(notificationsPageProvider.notifier).markAsRead(notification.id);
                            }
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
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const _NotificationTile({required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final typeColor = _colorForType(notification.type);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: notification.read ? AppTheme.surface : AppTheme.primary.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: notification.read ? AppTheme.border : AppTheme.primary.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(_iconForType(notification.type), color: typeColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: notification.read ? FontWeight.w500 : FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!notification.read) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppTheme.secondary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _timeAgo(notification.createdAt),
                        style: const TextStyle(fontSize: 11, color: AppTheme.textLight),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
