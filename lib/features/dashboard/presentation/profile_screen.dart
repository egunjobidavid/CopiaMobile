import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme.dart';
import '../../auth/presentation/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _biometricEnabled = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    final name = user?['name'] as String? ?? user?['firstName'] as String? ?? 'User';
    final email = user?['email'] as String? ?? '';
    final role = user?['role'] as String? ?? 'Member';
    final tenantId = authState.tenantId ?? 'N/A';
    final createdAt = user?['createdAt'] as String? ?? '';

    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _buildGradientHeader(initial, name, email, role),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _buildStatsSection(tenantId, createdAt),
                        const SizedBox(height: 28),
                        _buildSectionLabel('Account'),
                        _buildGroupedCards([
                          _SettingsTile(
                            icon: Icons.person_outline_rounded,
                            title: 'Edit Profile',
                            onTap: () {},
                          ),
                          _SettingsTile(
                            icon: Icons.lock_outline_rounded,
                            title: 'Change Password',
                            onTap: () {},
                          ),
                          _SettingsTile(
                            icon: Icons.fingerprint_rounded,
                            title: 'Biometric Login',
                            trailing: Switch(
                              value: _biometricEnabled,
                              activeColor: AppTheme.primary,
                              onChanged: (v) {
                                setState(() => _biometricEnabled = v);
                                ref.read(authStateProvider.notifier).setBiometricEnabled(v);
                              },
                            ),
                          ),
                        ]),
                        const SizedBox(height: 20),
                        _buildSectionLabel('Business'),
                        _buildGroupedCards([
                          _SettingsTile(
                            icon: Icons.business_center_outlined,
                            title: 'Company Info',
                            onTap: () {},
                          ),
                          _SettingsTile(
                            icon: Icons.location_on_outlined,
                            title: 'Locations',
                            onTap: () {},
                          ),
                        ]),
                        const SizedBox(height: 20),
                        _buildSectionLabel('Preferences'),
                        _buildGroupedCards([
                          _SettingsTile(
                            icon: Icons.payments_outlined,
                            title: 'Currency',
                            trailing: const Text(
                              '₦ Naira',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () {},
                          ),
                          _SettingsTile(
                            icon: Icons.language_rounded,
                            title: 'Language',
                            trailing: const Text(
                              'English',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () {},
                          ),
                          _SettingsTile(
                            icon: Icons.dark_mode_outlined,
                            title: 'Theme',
                            trailing: const Text(
                              'Light',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () {},
                          ),
                        ]),
                        const SizedBox(height: 20),
                        _buildSectionLabel('Support'),
                        _buildGroupedCards([
                          _SettingsTile(
                            icon: Icons.help_outline_rounded,
                            title: 'Help Center',
                            onTap: () {},
                          ),
                          _SettingsTile(
                            icon: Icons.privacy_tip_outlined,
                            title: 'Privacy Policy',
                            onTap: () {},
                          ),
                          _SettingsTile(
                            icon: Icons.description_outlined,
                            title: 'Terms of Service',
                            onTap: () {},
                          ),
                          _SettingsTile(
                            icon: Icons.info_outline_rounded,
                            title: 'App Version',
                            trailing: const Text(
                              'v1.0.0',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton.icon(
                            onPressed: () => _showLogoutDialog(context),
                            icon: const Icon(Icons.logout_rounded, color: AppTheme.error),
                            label: const Text(
                              'Log Out',
                              style: TextStyle(
                                color: AppTheme.error,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppTheme.error),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientHeader(String initial, String name, String email, String role) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppTheme.primaryGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  role,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(String tenantId, String createdAt) {
    String memberSince = 'N/A';
    if (createdAt.isNotEmpty) {
      try {
        final date = DateTime.parse(createdAt);
        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        memberSince = '${months[date.month - 1]} ${date.year}';
      } catch (_) {}
    }

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Member Since',
            value: memberSince,
            icon: Icons.calendar_today_outlined,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: 'Tenant ID',
            value: tenantId.length > 12 ? '${tenantId.substring(0, 12)}...' : tenantId,
            icon: Icons.business_outlined,
            color: AppTheme.accent,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppTheme.textSecondary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildGroupedCards(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              Divider(
                height: 1,
                indent: 52,
                color: AppTheme.dividerColor,
              ),
          ],
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Log Out',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(authStateProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            child: const Text(
              'Log Out',
              style: TextStyle(
                color: AppTheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: AppTheme.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            if (trailing != null)
              trailing!
            else
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppTheme.textLight,
              ),
          ],
        ),
      ),
    );
  }
}
