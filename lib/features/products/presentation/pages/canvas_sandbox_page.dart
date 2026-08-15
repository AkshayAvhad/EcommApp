import 'dart:isolate';

// import 'package:ecomm/core/services/generated_device_api.g.dart';
import 'package:ecomm/core/services/platform_device_service.dart';
import 'package:flutter/material.dart';
import 'package:ecomm/core/components/custom_circular_progress.dart';

class CanvasSandboxPage extends StatefulWidget {
  const CanvasSandboxPage({super.key});

  @override
  State<CanvasSandboxPage> createState() => _CanvasSandboxPageState();
}

class _CanvasSandboxPageState extends State<CanvasSandboxPage> {
  double _currentProgress = 0.35; // Initial progress: 35%

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Pipeline & Custom Paint Sandbox'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(
              'Interactive Render Object Test',
              style: TextStyle(
                fontSize: 18,
                fontWeight: .bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Current Value: ${(_currentProgress * 100).toStringAsFixed(0)}%',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),
            // ==========================================
            // OUR CUSTOM PAINTER COMPONENT IN ACTION!
            // ==========================================
            CustomCircularProgress(
              progress: _currentProgress,
              size: 220.0,
              progressColor: Colors.blueAccent,
            ),
            const SizedBox(height: 50),
            // Interactive Controls to trigger the Repaint/Rebuild loops
            Padding(
              padding: const .symmetric(horizontal: 32.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: .circular(16)),
                child: Column(
                  children: [
                    const Text(
                      'Modify State to Trigger Widget Rebuild',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Slider(
                      value: _currentProgress,
                      min: 0.0,
                      max: 1.0,
                      onChanged: (double newValue) {
                        setState(() {
                          _currentProgress = newValue;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: .spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            // freezeTheApp();
                            // print(
                            //   'BATTERY LEVEL: ${await PlatformDeviceService().getBatteryLevel()}',
                            // );

                            // final api = NativeDeviceApi();
                            // final BatteryResponse response = await api.getDetailedBattery();

                            // print("🔋 Battery is at: ${response.percentage}%");
                            // print("⚡ Is device charging? ${response.isCharging}");

                            setState(() {
                              _currentProgress = 0.0;
                            });
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reset'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () =>
                              setState(() => _currentProgress = 1.0),
                          icon: const Icon(Icons.check_circle),
                          label: const Text('Max out'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void freezeTheApp() async {
    //CODE WITH ISOLATE
    print("🚀 Offloading computation to an Isolate...");

    // We wrap the identical heavy loop inside Isolate.run
    int counter = await Isolate.run(() {
      int innerCounter = 0;
      for (int i = 0; i < 500000000; i++) {
        innerCounter += i;
      }
      print("✅ Background Isolate finished! Counter: $innerCounter");
      return innerCounter;
    });

    print("🎉 Main UI thread received completion signal! Value: $counter");

    //CODE WITHOUT ISOLATE
    // print("🚨 Starting massive computation on Main UI Thread...");
    // int counter = 0;
    // // Running a heavy synchronous loop 5 billion times
    // for (int i = 0; i < 500000000; i++) {
    //   counter += i;
    // }
    //
    // print("✅ Computation finished! Counter value: $counter");
  }
}
