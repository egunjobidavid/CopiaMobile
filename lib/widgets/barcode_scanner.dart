import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerWidget extends StatelessWidget {
  final void Function(String barcode) onDetect;
  final double height;

  const BarcodeScannerWidget({
    super.key,
    required this.onDetect,
    this.height = 250,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: MobileScanner(
        onDetect: (capture) {
          final barcode = capture.barcodes.first.rawValue;
          if (barcode != null) {
            onDetect(barcode);
          }
        },
      ),
    );
  }
}
