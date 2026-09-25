import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_gail/utils/res/environment_config.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  QRViewController? controller;

  final GlobalKey qrKey = GlobalKey();

  bool _isScanned = false;
  bool _isProcessing = false;

  String _scannedData = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Controller ko yahan dispose nahi karna hai.
        // dispose() automatically call hoga.
        return true;
      },
      child: Scaffold(
        appBar: AppBar(

          title: const Text('Scan QR Code'),
          backgroundColor: EnvironmentConfig.of(context)!.primaryTheme,
          foregroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // ==============================================================
              // QR CAMERA
              // ==============================================================
              Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                      overlay: QrScannerOverlayShape(
                        borderColor: EnvironmentConfig.of(context)!.primaryTheme,
                        borderRadius: 10,
                        borderLength: 30,
                        borderWidth: 8,
                        cutOutSize: 300,
                      ),
                    ),
          
                    // Instruction
                    Positioned(
                      top: 20,
                      left: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Point camera at QR code',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.grey[100],
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      if (_isScanned)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            border: Border.all(color: Colors.green, width: 1.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.green),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'QR Code scanned successfully',
                                  style: TextStyle(
                                    color: Colors.green[800],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
          
                      if (_isScanned) const SizedBox(height: 12),
                      if (_isScanned && !_isProcessing)
                        Row(
                          children: [
                            // AUTO LOAD
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _autoLoadAndClose,
                                icon: const Icon(Icons.check),
                                label: const Text('Auto Load'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
          
                            const SizedBox(width: 12),
          
                            // SCAN AGAIN
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _resetScanner,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Scan Again'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      // ========================================================
                      // PROCESSING
                      // ========================================================
                      else if (_isProcessing)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: EnvironmentConfig.of(context)!.primaryTheme.withValues(alpha: 50),
                            border: Border.all(color: EnvironmentConfig.of(context)!.primaryTheme, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Loading data... please wait',
                                style: TextStyle(
                                  color: EnvironmentConfig.of(context)!.primaryTheme,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: EnvironmentConfig.of(context)!.primaryTheme.withValues(alpha: 50),
                            border: Border.all(color: EnvironmentConfig.of(context)!.primaryTheme, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.info, color: EnvironmentConfig.of(context)!.primaryTheme),
                              SizedBox(width: 8),
                              Text(
                                'Scan QR code to load data',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    developer.log('📷 QR Camera initialized', name: 'QR_CAMERA');

    controller.scannedDataStream.listen((scanData) {
      if (_isScanned) {
        return;
      }

      final code = scanData.code;

      if (code == null || code.trim().isEmpty) {
        return;
      }

      // Pause camera immediately
      controller.pauseCamera();

      developer.log('✓ Camera paused after scan', name: 'QR_CAMERA');

      setState(() {
        _scannedData = code.trim();
        _isScanned = true;
      });

      developer.log('✓ QR Code scanned: $_scannedData', name: 'QR_CAMERA');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('QR Code scanned! Tap Auto Load'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void _resetScanner() {
    developer.log('🔄 Resetting scanner...', name: 'QR_SUBMIT');

    setState(() {
      _scannedData = '';
      _isScanned = false;
      _isProcessing = false;
    });

    controller?.resumeCamera();

    developer.log('✓ Camera resumed', name: 'QR_CAMERA');
  }

  // ==========================================================================
  // AUTO LOAD AND CLOSE
  // ==========================================================================
  Future<void> _autoLoadAndClose() async {
    if (_scannedData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No QR data found'),
          backgroundColor: EnvironmentConfig.of(context)!.primaryTheme,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    developer.log(
      '📤 Processing scanned data: $_scannedData',
      name: 'QR_SUBMIT',
    );

    // Small delay for UI
    await Future.delayed(const Duration(milliseconds: 500));

    dynamic parsedData;

    try {
      parsedData = jsonDecode(_scannedData);

      if (parsedData is Map) {
        developer.log('✓ Successfully parsed as JSON', name: 'QR_SUBMIT');

        developer.log(
          '📊 JSON Keys: ${parsedData.keys.toList()}',
          name: 'QR_SUBMIT',
        );
      } else {
        developer.log('⚠️ JSON is not a Map', name: 'QR_SUBMIT');
      }
    } catch (e) {
      developer.log('⚠️ Not valid JSON: $e', name: 'QR_SUBMIT');

      // If QR contains normal text
      parsedData = _scannedData;
    }

    developer.log('✓ Returning parsed data to BLoC', name: 'QR_SUBMIT');

    // Return data to AddTlpSurveyBloc
    if (!mounted) {
      return;
    }

    Navigator.pop(context, parsedData);

    developer.log('✓ QR Scanner closed', name: 'QR_SUBMIT');
  }

  // ==========================================================================
  // DISPOSE
  // ==========================================================================
  @override
  void dispose() {
    developer.log('🗑️ Disposing QR Scanner resources', name: 'QR_CAMERA');

    controller?.dispose();

    super.dispose();
  }
}
