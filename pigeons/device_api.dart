import 'package:pigeon/pigeon.dart';

// Configure output paths where Pigeon will auto-generate code files
@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/core/services/generated_device_api.g.dart',
    kotlinOut:
        'android/app/src/main/kotlin/com/ecomm/ecomm/GeneratedDeviceApi.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.ecomm.ecomm'),
  ),
)

// Define the structured data response object
class BatteryResponse {
  final int percentage;
  final bool isCharging;

  BatteryResponse({required this.percentage, required this.isCharging});
}

// Define the interface that the Native Host must implement
@HostApi()
abstract class NativeDeviceApi {
  BatteryResponse getDetailedBattery();
}