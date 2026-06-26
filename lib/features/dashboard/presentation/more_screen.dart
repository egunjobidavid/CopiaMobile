import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../../core/theme.dart';

class MoreScreen extends ConsumerStatefulWidget {
  const MoreScreen({super.key});

  @override
  ConsumerState<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends ConsumerState<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    final userName = user?['name'] as String? ?? user?['firstName'] as String? ?? 'User';
    final userEmail = user?['email'] as String? ?? 'user@copiaos.com';
    final userRole = user?['role'] as String? ?? 'Owner';

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
                      'More',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildProfileCard(
                      name: userName,
                      email: userEmail,
                      role: userRole,
                    ),
                    const SizedBox(height: 28),
                    _buildSection(
                      'Sell',
                      [
                        const _MenuItem(
                          icon: Icons.point_of_sale_rounded,
                          title: 'Point of Sale',
                          subtitle: 'Sell products from your phone',
                          color: AppTheme.success,
                          route: '/pos',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSection(
                      'Operations',
                      [
                        const _MenuItem(
                          icon: Icons.swap_horiz_rounded,
                          title: 'Stock Transfers',
                          subtitle: 'Move stock between locations',
                          color: Color(0xFF06B6D4),
                          route: '/stock-transfers',
                        ),
                        const _MenuItem(
                          icon: Icons.receipt_long_rounded,
                          title: 'Expense Claims',
                          subtitle: 'Track business spending',
                          color: Color(0xFFEF4444),
                          route: '/expense-claims',
                        ),
                        const _MenuItem(
                          icon: Icons.fact_check_rounded,
                          title: 'Approvals',
                          subtitle: 'Pending approvals queue',
                          color: Color(0xFFF59E0B),
                          route: '/approvals',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSection(
                      'Team',
                      [
                        const _MenuItem(
                          icon: Icons.admin_panel_settings_rounded,
                          title: 'Staff Permissions',
                          subtitle: 'Activate/deactivate modules for staff',
                          color: Color(0xFF8B5CF6),
                          route: '/staff-modules',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSection(
                      'Account',
                      [
                        const _MenuItem(
                          icon: Icons.person_rounded,
                          title: 'Profile & Settings',
                          subtitle: 'Manage your account',
                          color: AppTheme.primary,
                          route: '/profile',
                        ),
                        const _MenuItem(
                          icon: Icons.notifications_rounded,
                          title: 'Notifications',
                          subtitle: 'Manage alert preferences',
                          color: Color(0xFF6366F1),
                          route: '/notifications',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildLogoutButton(context, ref),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard({
    required String name,
    required String email,
    required String role,
  }) {
    return GestureDetector(
      onTap: () => context.push('/profile'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppTheme.warmGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      role,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<_MenuItem> items) {
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
        Container(
          decoration: AppTheme.cardDecoration,
          child: Column(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isFirst = index == 0;
              final isLast = index == items.length - 1;
              return _buildMenuItem(item, isFirst, isLast);
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(_MenuItem item, bool isFirst, bool isLast) {
    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: AppTheme.border.withValues(alpha: 0.5),
                  width: 0.5,
                ),
              ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.vertical(
            top: isFirst ? const Radius.circular(20) : Radius.zero,
            bottom: isLast ? const Radius.circular(20) : Radius.zero,
          ),
          onTap: item.route != null ? () => _navigate(item.route!) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: item.color, size: 20),
                ),
                const SizedBox(width: 14),
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
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textSecondary.withValues(alpha: 0.4),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigate(String route) {
    context.push(route);
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        final shouldLogout = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text(
              'Sign Out',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: AppTheme.error),
                child: const Text('Sign Out'),
              ),
            ],
          ),
        );
        if (shouldLogout == true && context.mounted) {
          await ref.read(authStateProvider.notifier).logout();
          if (context.mounted) context.go('/login');
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.error.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.error.withValues(alpha: 0.15)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: AppTheme.error, size: 20),
            SizedBox(width: 8),
            Text(
              'Sign Out',
              style: TextStyle(
                color: AppTheme.error,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String? route;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.route,
  });
}
