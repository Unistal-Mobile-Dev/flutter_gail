import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gail/ExportFile/app_export_file.dart';

/// QrScannerScreen - Full-featured QR code scanner with camera
class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  late MobileScannerController controller;
  bool _flashEnabled = false;
  bool _isFrontCamera = false;
  bool _hasScanned = false; // Prevent multiple scans

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      facing: CameraFacing.back,
     // enableAudio: true,
      autoStart: true,
    );
    _requestCameraPermission();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Request camera permission
  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();

    if (status.isDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission is required')),
        );
        Navigator.pop(context);
      }
    } else if (status.isPermanentlyDenied) {
      if (mounted) {
        _showPermissionDialog();
      }
    }
  }

  /// Show dialog for permanently denied permission
  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Camera Permission Required'),
        content: const Text(
          'Camera permission is permanently denied. '
              'Please enable it in app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// Toggle flashlight
  void _toggleFlash() {
    setState(() {
      _flashEnabled = !_flashEnabled;
      controller.toggleTorch();
    });
  }

  /// Switch camera (front/back)
  void _switchCamera() {
    setState(() {
      _isFrontCamera = !_isFrontCamera;
      controller.switchCamera();
    });
  }

  /// Handle QR code detection
  void _handleQrCode(BarcodeCapture barcodes) {
    if (_hasScanned) return; // Prevent multiple scans

    for (final barcode in barcodes.barcodes) {
      final value = barcode.rawValue;

      if (value != null && value.isNotEmpty) {
        _hasScanned = true;

        // Try to parse as JSON
        try {
          // Remove common QR code prefixes if any
          String cleanValue = value.trim();

          // Check if it's valid JSON
          if (cleanValue.startsWith('{') && cleanValue.endsWith('}')) {
            // It's JSON - return as is
            _returnScannedData(cleanValue);
          } else {
            // Try to treat as plain text or URL
            _returnScannedData(cleanValue);
          }
        } catch (e) {
          _showError('Invalid QR Code Format: ${e.toString()}');
          _hasScanned = false;
        }
      }
    }
  }

  /// Return scanned data and close scanner
  void _returnScannedData(String data) {
    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('QR Code Scanned Successfully!'),
        duration: Duration(milliseconds: 800),
      ),
    );

    // Small delay to show the snackbar
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pop(context, data);
      }
    });
  }

  /// Show error dialog
  void _showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: AppColor.themeColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Camera view
          MobileScanner(
            controller: controller,
            onDetect: _handleQrCode,
            // errorBuilder: (context, error, child) => Center(
            //   child: Text(
            //     'Error: ${error.errorCode}',
            //     style: const TextStyle(color: Colors.white),
            //   ),
            // ),
            // overlay: Padding(
            //   padding: const EdgeInsets.all(50.0),
            //   child: Stack(
            //     children: [
            //       // Corner indicators
            //       Positioned(
            //         top: 0,
            //         left: 0,
            //         child: _buildCorner(Alignment.topLeft),
            //       ),
            //       Positioned(
            //         top: 0,
            //         right: 0,
            //         child: _buildCorner(Alignment.topRight),
            //       ),
            //       Positioned(
            //         bottom: 0,
            //         left: 0,
            //         child: _buildCorner(Alignment.bottomLeft),
            //       ),
            //       Positioned(
            //         bottom: 0,
            //         right: 0,
            //         child: _buildCorner(Alignment.bottomRight),
            //       ),
            //       // Center text
            //       Center(
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             const SizedBox(height: 50),
            //             const Text(
            //               'Position QR Code Here',
            //               style: TextStyle(
            //                 color: Colors.white,
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.w500,
            //               ),
            //             ),
            //             const SizedBox(height: 20),
            //             _buildAnimatedScanner(),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ),

          // Bottom control buttons
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Flashlight button
                FloatingActionButton(
                  mini: true,
                  onPressed: _toggleFlash,
                  backgroundColor: _flashEnabled
                      ? Colors.yellow.shade700
                      : Colors.grey.shade700,
                  child: Icon(
                    _flashEnabled ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                // Switch camera button
                FloatingActionButton(
                  mini: true,
                  onPressed: _switchCamera,
                  backgroundColor: Colors.grey.shade700,
                  child: Icon(
                    _isFrontCamera
                        ? Icons.camera_front
                        : Icons.camera_rear,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build corner indicator
  Widget _buildCorner(Alignment alignment) {
    const double cornerWidth = 20;
    const double cornerHeight = 20;
    const double thickness = 3;

    return Container(
      width: cornerWidth,
      height: cornerHeight,
      decoration: BoxDecoration(
        border: Border(
          top: alignment == Alignment.topLeft || alignment == Alignment.topRight
              ? const BorderSide(color: Colors.green, width: thickness)
              : BorderSide.none,
          bottom: alignment == Alignment.bottomLeft ||
              alignment == Alignment.bottomRight
              ? const BorderSide(color: Colors.green, width: thickness)
              : BorderSide.none,
          left: alignment == Alignment.topLeft || alignment == Alignment.bottomLeft
              ? const BorderSide(color: Colors.green, width: thickness)
              : BorderSide.none,
          right: alignment == Alignment.topRight ||
              alignment == Alignment.bottomRight
              ? const BorderSide(color: Colors.green, width: thickness)
              : BorderSide.none,
        ),
      ),
    );
  }

  /// Build animated scanner line
  Widget _buildAnimatedScanner() {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.5),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          // Animated scanning line
          Center(
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: -250, end: 250),
              duration: const Duration(seconds: 2),
              builder: (context, double value, child) {
                return Transform.translate(
                  offset: Offset(0, value),
                  child: Container(
                    height: 2,
                    width: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.green.withValues(alpha: 0),
                          Colors.green,
                          Colors.green.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                );
              },
              onEnd: () => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }
}