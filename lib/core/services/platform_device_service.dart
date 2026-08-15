// // import 'package:ecomm/core/services/generated_device_api.g.dart';
// import 'package:flutter/services.dart';
//
// class PlatformDeviceService {
//   static const MethodChannel _channel = MethodChannel(
//     'com.ecomm.ecomm/device_info',
//   );
//
//   Future<int> getBatteryLevel() async {
//     try {
//       final int battery = await _channel.invokeMethod('getBatteryLevel');
//       return battery;
//     } on PlatformException catch (e) {
//       print('Native Method Channel Error: ${e.message}');
//       return -1;
//     }
//   }
//
//   Future<void> checkBatteryStatus() async {
//     final api = NativeDeviceApi();
//
//     final BatteryResponse response = await api.getDetailedBattery();
//
//     print("🔋 Battery is at: ${response.percentage}%");
//     print("⚡ Is device charging? ${response.isCharging}");
//   }
// }
