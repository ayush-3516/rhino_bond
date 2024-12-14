import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerController {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isFlashOn = false;

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Handle scanned data
      if (scanData.code != null) {
        onBarcodeScanned(scanData.code!);
      } else {
        debugPrint('Scanned data is null');
      }
    });
  }

  void toggleFlash() {
    controller?.toggleFlash().then((_) {
      isFlashOn = !isFlashOn;
    });
  }

  void onBarcodeScanned(String barcode) {
    // Handle barcode data
    debugPrint('Barcode scanned: $barcode');
    // Add additional logic to process the barcode data as needed
  }

  void dispose() {
    controller?.dispose();
  }
}
