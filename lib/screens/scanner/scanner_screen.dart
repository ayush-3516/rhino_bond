import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rhino_bond/widgets/custom_app_drawer.dart';
import 'package:rhino_bond/services/scanner_service.dart';
import 'package:rhino_bond/screens/scanner/components/scanner_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logging/logging.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final TextEditingController _barcodeController = TextEditingController();
  QRViewController? controller;
  bool isFlashOn = false;
  final _scannerService = ScannerService();

  @override
  void initState() {
    super.initState();
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  Future<void> _processCode(String code) async {
    try {
      // First get product information without processing
      final productInfo = await _scannerService.getProductInfo(code);

      // Extract product information
      final productName = productInfo['productName'] ?? 'Unknown Product';
      final qrId = productInfo['id'] ?? 'N/A';
      final manualId = productInfo['manualIdentifier'] ?? 'N/A';
      final points = productInfo['points'] ?? '0';

      _showConfirmationDialog(
        '''
Product: $productName
QR Code ID: $qrId
Manual Identifier: $manualId
Points Earned: $points
        ''',
        'Scan Successful',
        onConfirm: () async {
          Navigator.pop(context);
          await _processConfirmedCode(code);
        },
        onCancel: () {
          Navigator.pop(context);
          controller?.resumeCamera();
        },
      );
    } on FormatException {
      _showScannedDialog(
        'Invalid Code',
        'The scanned code is not in the correct format. Please scan a valid Rhino Bond QR code.',
        onContinue: () => controller?.resumeCamera(),
      );
    } on Exception catch (e) {
      if (e.toString().contains('already scanned')) {
        final match = RegExp(r'scanned on (.*)\.').firstMatch(e.toString());
        final timestamp = match?.group(1) ?? 'previously';
        _showScannedDialog(
          'QR Code Already Scanned',
          'This QR code was already scanned on:\n\n$timestamp\n\nPlease scan a different code.',
          onContinue: () => controller?.resumeCamera(),
        );
      } else {
        _showScannedDialog(
          'Error',
          e.toString(),
          onContinue: () => controller?.resumeCamera(),
        );
      }
    }
  }

  void _submitManualCode() {
    final code = _barcodeController.text.trim();
    if (code.isEmpty) {
      _showScannedDialog(
        'Error',
        'Please enter a code',
        onContinue: () => controller?.resumeCamera(),
      );
      return;
    }

    final sanitizedCode = code.replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '');
    _processCode(sanitizedCode);
  }

  Future<void> _checkCameraPermissions() async {
    try {
      await _scannerService.checkCameraPermissions();
    } catch (e) {
      _showScannedDialog(
        'Permission Error',
        e.toString(),
        onContinue: () => Navigator.pop(context),
      );
      rethrow;
    }
  }

  void _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;

    try {
      // Check camera permissions first
      await _checkCameraPermissions();

      // Configure camera settings
      await controller.resumeCamera();

      // Ensure flash is off
      await controller.toggleFlash();
      await controller.toggleFlash();

      // Handle camera initialization
      final cameraInfo = await controller.getCameraInfo();
      if (cameraInfo == null) {
        throw Exception('Unable to access camera');
      }

      // Handle camera stream with longer timeout
      controller.scannedDataStream.timeout(const Duration(seconds: 30),
          onTimeout: (sink) {
        sink.addError('Camera timeout - please try again');
        controller.pauseCamera();
      }).listen(
        (scanData) async {
          if (scanData.code != null) {
            controller.pauseCamera();
            await _processCode(scanData.code!);
          }
        },
        onError: (error) {
          _showScannedDialog(
            'Camera Error',
            error.toString(),
            onContinue: () => controller?.resumeCamera(),
          );
        },
        cancelOnError: true,
      );
    } catch (e) {
      _showScannedDialog(
        'Camera Error',
        e.toString(),
        onContinue: () => controller?.resumeCamera(),
      );
    }
  }

  Future<void> _processConfirmedCode(String code) async {
    try {
      await _scannerService.processCode(code);
      _showScannedDialog(
        'Processing Complete',
        'The QR code has been successfully processed!',
        onContinue: () => controller?.resumeCamera(),
      );
    } catch (e) {
      _showScannedDialog(
        'Error',
        e.toString(),
        onContinue: () => controller?.resumeCamera(),
      );
    }
  }

  void _showScannedDialog(String title, String message,
      {VoidCallback? onContinue}) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        title: Column(
          children: [
            Icon(
              Icons.check_circle,
              color: Theme.of(context).primaryColor,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Thank you for scanning!',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                onContinue?.call();
              },
              child: const Text(
                'Continue Scanning',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(String message, String title,
      {VoidCallback? onConfirm, VoidCallback? onCancel}) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        title: Column(
          children: [
            Icon(
              Icons.check_circle,
              color: Theme.of(context).primaryColor,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Thank you for scanning!',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onPressed: onCancel,
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: onConfirm,
                    child: const Text(
                      'Confirm',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: CustomAppDrawer(),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          const ScannerOverlay(
            overlayColor: Colors.black87,
            scanLineColor: Color(0xFF00E676),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Align QR code within the frame to scan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFlashOn ? Icons.flash_on : Icons.flash_off,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () async {
                        await controller?.toggleFlash();
                        setState(() {
                          isFlashOn = !isFlashOn;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Or, Enter the bar code manually',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _barcodeController,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Enter barcode',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.7)),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.3),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.send,
                              color: Colors.white, size: 20),
                          onPressed: _submitManualCode,
                        ),
                      ),
                    ),
                    onSubmitted: (_) => _submitManualCode(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
