import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import '../../../widgets/signature_pad.dart';

class SignatureCaptureScreen extends StatefulWidget {
  final void Function(Uint8List? pngBytes)? onSave;

  const SignatureCaptureScreen({super.key, this.onSave});

  @override
  State<SignatureCaptureScreen> createState() => _SignatureCaptureScreenState();
}

class _SignatureCaptureScreenState extends State<SignatureCaptureScreen> {
  final _sigPadKey = GlobalKey<SignaturePadState>();

  Future<void> _save() async {
    final state = _sigPadKey.currentState;
    if (state == null) return;
    final image = await state.captureSignature();
    if (image == null) return;
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;
    final pngBytes = byteData.buffer.asUint8List();
    widget.onSave?.call(pngBytes);
    if (mounted) Navigator.pop(context, pngBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Signature'),
        actions: [
          TextButton(onPressed: () => _sigPadKey.currentState?.clear(), child: const Text('Clear')),
          TextButton(onPressed: _save, child: const Text('Use Signature')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Please sign above the line', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),
            SignaturePad(key: _sigPadKey, height: 250),
            const SizedBox(height: 8),
            Text('Sign using your finger', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
