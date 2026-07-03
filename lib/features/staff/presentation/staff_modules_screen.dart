import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage.dart';

final staffListProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final api = ref.watch(apiClientProvider);
  final response = await api.get('/staff');
  return extractList(response.data);
});

final staffModulesProvider =
    FutureProvider.family<Map<String, bool>, String>((ref, staffId) async {
  final api = ref.watch(apiClientProvider);
  final staffResponse = await api.get('/staff');
  final staffList = extractList(staffResponse.data);
  final staff = staffList.firstWhere(
        (s) => s['id'].toString() == staffId,
        orElse: () => {},
      );
  final roleId = staff['roleId']?.toString() ?? staff['role_id']?.toString();
  if (roleId == null) return {};
  final response = await api.get('/tenants/roles/$roleId/modules');
  final data = extractOne(response.data) ?? <String, dynamic>{};
  final raw = data['modules'];
  Map<String, bool> parsed = {};
  if (raw is List) {
    for (final m in raw) {
      parsed[m.toString()] = true;
    }
  } else if (raw is Map) {
    parsed = raw.map((k, v) => MapEntry(k.toString(), v == true));
  }
  return parsed;
});

class StaffModulesScreen extends ConsumerStatefulWidget {
  const StaffModulesScreen({super.key});

  @override
  ConsumerState<StaffModulesScreen> createState() => _StaffModulesScreenState();
}

class _StaffModulesScreenState extends ConsumerState<StaffModulesScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final staffAsync = ref.watch(staffListProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Staff Permissions',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Manage module access for your team',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Search staff...',
                  prefixIcon: const Icon(Icons.search, color: AppTheme.textLight),
                  filled: true,
                  fillColor: const Color(0xFFF5F6FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: staffAsync.when(
                data: (staffList) {
                  final filtered = _searchQuery.isEmpty
                      ? staffList
                      : staffList
                          .where((s) => (s['user']?['name'] ?? '')
                              .toString()
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()))
                          .toList();
                  if (filtered.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.people_outline,
                              size: 64, color: AppTheme.textLight),
                          SizedBox(height: 12),
                          Text('No staff found',
                              style: TextStyle(
                                  color: AppTheme.textSecondary, fontSize: 16)),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async =>
                        ref.invalidate(staffListProvider),
                    color: AppTheme.primary,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) =>
                          _StaffCard(data: filtered[index]),
                    ),
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: AppTheme.error),
                      const SizedBox(height: 12),
                      const Text('Failed to load staff',
                          style: TextStyle(
                              color: AppTheme.textSecondary, fontSize: 16)),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => ref.invalidate(staffListProvider),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
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
}

class _StaffCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _StaffCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final user = data['user'] as Map<String, dynamic>? ?? {};
    final name = user['name'] as String? ?? 'Unknown';
    final jobTitle = data['jobTitle'] as String? ?? '';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => _ModuleEditorScreen(staffData: data),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                initial,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  if (jobTitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      jobTitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'modules',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppTheme.textLight),
          ],
        ),
      ),
    );
  }
}

class _ModuleEditorScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> staffData;
  const _ModuleEditorScreen({required this.staffData});

  @override
  ConsumerState<_ModuleEditorScreen> createState() =>
      _ModuleEditorScreenState();
}

class _ModuleEditorScreenState extends ConsumerState<_ModuleEditorScreen> {
  Map<String, bool> _modules = {};
  bool _loading = true;
  bool _saving = false;
  String? _error;

  static const _moduleDefinitions = <_ModuleDef>[
    _ModuleDef('sales', 'Sales', Icons.point_of_sale, 'Orders, invoices, quotes'),
    _ModuleDef('inventory', 'Inventory', Icons.inventory_2, 'Products, stock, transfers'),
    _ModuleDef('accounting', 'Accounting', Icons.account_balance, 'Journal entries, reports'),
    _ModuleDef('hr', 'HR', Icons.groups, 'Staff, leave, payroll'),
    _ModuleDef('procurement', 'Procurement', Icons.shopping_cart, 'Purchase orders'),
    _ModuleDef('crm', 'CRM', Icons.handshake, 'Customers, pipeline'),
    _ModuleDef('projects', 'Projects', Icons.task_alt, 'Tasks, time tracking'),
    _ModuleDef('production', 'Production', Icons.precision_manufacturing, 'BOM, work orders'),
    _ModuleDef('approvals', 'Approvals', Icons.check_circle, 'Leave, expenses, PO approvals'),
    _ModuleDef('analytics', 'Analytics', Icons.analytics, 'Dashboard, reports'),
    _ModuleDef('pos', 'POS', Icons.store, 'Point of sale'),
    _ModuleDef('billing', 'Billing', Icons.receipt_long, 'Subscriptions, plans'),
  ];

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  Future<void> _loadModules() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final api = ref.read(apiClientProvider);
      final roleId = widget.staffData['roleId']?.toString() ??
          widget.staffData['role_id']?.toString();
      if (roleId == null) {
        setState(() {
          _error = 'Staff member has no role assigned';
          _loading = false;
        });
        return;
      }
      final response = await api.get('/tenants/roles/$roleId/modules');
      final data = extractOne(response.data) ?? <String, dynamic>{};
      final raw = data['modules'];
      Map<String, bool> parsed = {};
      if (raw is List) {
        for (final m in raw) {
          parsed[m.toString()] = true;
        }
      } else if (raw is Map) {
        parsed = raw.map((k, v) => MapEntry(k.toString(), v == true));
      }
      setState(() {
        _modules = parsed;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final api = ref.read(apiClientProvider);
      final roleId = widget.staffData['roleId']?.toString() ??
          widget.staffData['role_id']?.toString();
      if (roleId == null) throw Exception('Staff member has no role assigned');
      final enabledModules = _modules.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();
      await api.put('/tenants/roles/$roleId/modules', data: {'modules': enabledModules});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Module permissions updated'),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: AppTheme.error,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user =
        widget.staffData['user'] as Map<String, dynamic>? ?? {};
    final name = user['name'] as String? ?? 'Unknown';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: const Text('Module Permissions'),
          backgroundColor: Colors.white,
          foregroundColor: AppTheme.textPrimary,
          elevation: 0,
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: AppTheme.error),
                        const SizedBox(height: 12),
                        const Text('Failed to load modules',
                            style: TextStyle(
                                color: AppTheme.textSecondary, fontSize: 16)),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _loadModules,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        color: Colors.white,
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                initial,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Toggle modules on/off for $name',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          itemCount: _moduleDefinitions.length,
                          itemBuilder: (context, index) {
                            final def = _moduleDefinitions[index];
                            final active = _modules[def.key] ?? false;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: active
                                      ? AppTheme.success.withValues(alpha: 0.4)
                                      : AppTheme.border,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: active
                                          ? AppTheme.success.withValues(alpha: 0.12)
                                          : AppTheme.textLight.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      def.icon,
                                      size: 22,
                                      color: active
                                          ? AppTheme.success
                                          : AppTheme.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          def.label,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: active
                                                ? AppTheme.textPrimary
                                                : AppTheme.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          def.description,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.textLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 32,
                                    child: Switch(
                                      value: active,
                                      onChanged: (v) {
                                        setState(() {
                                          _modules[def.key] = v;
                                        });
                                      },
                                      activeThumbColor: AppTheme.success,
                                      inactiveTrackColor:
                                          AppTheme.border,
                                      thumbColor:
                                          WidgetStateProperty.resolveWith(
                                              (states) {
                                        if (states.contains(
                                            WidgetState.selected)) {
                                          return Colors.white;
                                        }
                                        return Colors.white;
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: _saving
                                  ? null
                                  : AppTheme.primaryGradient,
                              color: _saving ? AppTheme.textLight : null,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: ElevatedButton(
                              onPressed: _saving ? null : _save,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                disabledBackgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: _saving
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Save Changes',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class _ModuleDef {
  final String key;
  final String label;
  final IconData icon;
  final String description;
  const _ModuleDef(this.key, this.label, this.icon, this.description);
}
