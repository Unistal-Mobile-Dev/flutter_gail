// // lib/feature/tlpSurvey/addTlpSurvey/domain/service/qr_scanner_service.dart
//
// import 'dart:convert';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_gail/feature/tlpSurvey/addTlpSurvey/domain/model/qr_scan_data_model.dart';
//
// class QrScannerService {
//   static final QrScannerService _instance = QrScannerService._internal();
//
//   factory QrScannerService() {
//     return _instance;
//   }
//
//   QrScannerService._internal();
//
//   /// Request camera permission
//   Future<bool> requestCameraPermission() async {
//     final status = await Permission.camera.request();
//     return status.isGranted;
//   }
//
//   /// Check if camera permission is granted
//   Future<bool> isCameraPermissionGranted() async {
//     final status = await Permission.camera.status;
//     return status.isGranted;
//   }
//
//   /// Parse QR code data into QrScanDataModel
//   QrScanDataModel? parseQrData(String qrContent) {
//     try {
//       // Try to decode as JSON
//       final Map<String, dynamic> jsonData = jsonDecode(qrContent);
//       return QrScanDataModel.fromJson(jsonData);
//     } catch (e) {
//       print('Failed to parse QR data: $e');
//       return null;
//     }
//   }
//
//   /// Encode data to JSON string for QR code generation
//   String encodeQrData(QrScanDataModel data) {
//     try {
//       return jsonEncode(data.toJson());
//     } catch (e) {
//       print('Failed to encode QR data: $e');
//       return '';
//     }
//   }
// }