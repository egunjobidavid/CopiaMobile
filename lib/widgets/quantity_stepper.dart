import 'package:flutter/material.dart';

class QuantityStepper extends StatelessWidget {
  final double quantity;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final double step;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.min = 0.5,
    this.max = 9999,
    this.step = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: quantity > min ? () => onChanged((quantity - step).clamp(min, max)) : null,
        ),
        SizedBox(
          width: 48,
          child: Text(
            quantity.toStringAsFixed(quantity == quantity.roundToDouble() ? 0 : 1),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: quantity < max ? () => onChanged((quantity + step).clamp(min, max)) : null,
        ),
      ],
    );
  }
}
