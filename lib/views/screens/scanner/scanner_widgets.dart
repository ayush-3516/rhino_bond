import 'package:flutter/material.dart';

class ScannerWidgets {
  static Widget buildFlashButton(bool isFlashOn, Function toggleFlash) {
    return IconButton(
      icon: Icon(
        isFlashOn ? Icons.flash_on : Icons.flash_off,
        color: Colors.white,
      ),
      onPressed: () => toggleFlash(),
    );
  }

  static Widget buildManualInputButton(Function onPressed) {
    return TextButton(
      onPressed: () => onPressed(),
      child: const Text(
        'Enter Manually',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  static Widget buildScanResultDialog(
      BuildContext context, String code, Function onContinue, Function onDone) {
    return AlertDialog(
      title: const Text('QR Code Detected'),
      content: Text('Scanned Code: $code'),
      actions: [
        TextButton(
          onPressed: () => onContinue(),
          child: const Text('Continue Scanning'),
        ),
        TextButton(
          onPressed: () => onDone(),
          child: const Text('Done'),
        ),
      ],
    );
  }
}
