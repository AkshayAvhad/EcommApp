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
                          onPressed: () =>
                              setState(() => _currentProgress = 0.0),
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
}
