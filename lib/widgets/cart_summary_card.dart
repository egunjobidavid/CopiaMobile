import 'package:flutter/material.dart';

class CartSummaryCard extends StatelessWidget {
  final int itemCount;
  final double subtotal;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  const CartSummaryCard({
    super.key,
    required this.itemCount,
    required this.subtotal,
    this.isSubmitting = false,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$itemCount item${itemCount == 1 ? '' : 's'}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₦${subtotal.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: isSubmitting || itemCount == 0 ? null : onSubmit,
              icon: isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.check),
              label: Text(isSubmitting ? 'Submitting...' : 'Submit Order'),
            ),
          ],
        ),
      ),
    );
  }
}
