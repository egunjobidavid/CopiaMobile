import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onSubmitted;
  final VoidCallback? onScanTap;
  final VoidCallback? onClear;

  const SearchBarWidget({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    required this.onSubmitted,
    this.onScanTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onClear != null && controller.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: onClear,
              ),
            if (onScanTap != null)
              IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: onScanTap,
              ),
          ],
        ),
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: onSubmitted,
    );
  }
}
