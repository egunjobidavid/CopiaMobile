import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/sales/presentation/sales_provider.dart';

class CustomerPicker extends ConsumerWidget {
  final Map<String, dynamic>? selected;
  final ValueChanged<Map<String, dynamic>> onSelected;

  const CustomerPicker({super.key, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => _showPicker(context, ref),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.person_outline, color: Colors.grey[500]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selected != null
                        ? '${selected!['firstName'] ?? ''} ${selected!['lastName'] ?? ''}'
                        : 'Walk-in Customer',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  if (selected != null && selected!['email'] != null)
                    Text(
                      selected!['email'] as String,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                ],
              ),
            ),
            if (selected != null)
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => onSelected({}),
              ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.3,
              maxChildSize: 0.85,
              expand: false,
              builder: (_, scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('Select Customer', style: Theme.of(ctx).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: 'Search customers...',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (_) => setModalState(() {}),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: controller.text.isEmpty
                            ? ListView(
                                controller: scrollController,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.person),
                                    title: const Text('Walk-in Customer'),
                                    onTap: () {
                                      onSelected({});
                                      Navigator.pop(ctx);
                                    },
                                  ),
                                ],
                              )
                            : ref.watch(customerSearchProvider(controller.text.trim())).when(
                                loading: () => const Center(child: CircularProgressIndicator()),
                                error: (_, __) => const Text('No results'),
                                data: (customers) => ListView(
                                  controller: scrollController,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.person),
                                      title: const Text('Walk-in Customer'),
                                      onTap: () {
                                        onSelected({});
                                        Navigator.pop(ctx);
                                      },
                                    ),
                                    ...customers.map((c) => ListTile(
                                      leading: const Icon(Icons.business),
                                      title: Text('${c['firstName'] ?? ''} ${c['lastName'] ?? ''}'),
                                      subtitle: Text(c['email'] ?? ''),
                                      onTap: () {
                                        onSelected(c);
                                        Navigator.pop(ctx);
                                      },
                                    )),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
