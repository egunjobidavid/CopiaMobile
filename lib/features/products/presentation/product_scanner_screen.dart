import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ProductScannerScreen extends StatelessWidget {
  const ProductScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Product'),
      ),
      body: MobileScanner(
        onDetect: (capture) {
          final barcode = capture.barcodes.first.rawValue;
          if (barcode != null) {
            Navigator.pop(context, barcode);
          }
        },
      ),
    );
  }
}
