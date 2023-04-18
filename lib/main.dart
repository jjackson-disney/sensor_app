import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FpsOverlay(child: SensorData()),
    );
  }
}

class SensorData extends StatefulWidget {
  SensorData({Key? key}) : super(key: key);
  
  @override
  _SensorDataState createState() => _SensorDataState();
}

class _SensorDataState extends State<SensorData> {
  AccelerometerEvent? _accelerometerEvent;
  GyroscopeEvent? _gyroscopeEvent;
  MagnetometerEvent? _magnetometerEvent;

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerEvent = event;
      });
    });

    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeEvent = event;
      });
    });

    magnetometerEvents.listen((MagnetometerEvent event) {
      setState(() {
        _magnetometerEvent = event;
      });
    });
  }

  String valueOrNotAvailable(double? value) {
    return value != null ? value.toStringAsFixed(2) : "Not Available for this Device";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sensor App')),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('Accelerometer'),
            subtitle: Text(
                'X: ${valueOrNotAvailable(_accelerometerEvent?.x)}\nY: ${valueOrNotAvailable(_accelerometerEvent?.y)}\nZ: ${valueOrNotAvailable(_accelerometerEvent?.z)}'),
          ),
          ListTile(
            title: Text('Gyroscope'),
            subtitle: Text(
                'X: ${valueOrNotAvailable(_gyroscopeEvent?.x)}\nY: ${valueOrNotAvailable(_gyroscopeEvent?.y)}\nZ: ${valueOrNotAvailable(_gyroscopeEvent?.z)}'),
          ),
          ListTile(
            title: Text('Magnetometer'),
            subtitle: Text(
                'X: ${valueOrNotAvailable(_magnetometerEvent?.x)}\nY: ${valueOrNotAvailable(_magnetometerEvent?.y)}\nZ: ${valueOrNotAvailable(_magnetometerEvent?.z)}'),
          ),
          // Add more ListTile widgets for other sensors
        ],
      ),
    );
  }
}

class FpsOverlay extends StatefulWidget {
  final Widget child;

  FpsOverlay({Key? key, required this.child}) : super(key: key);

  @override
  _FpsOverlayState createState() => _FpsOverlayState();
}

class _FpsOverlayState extends State<FpsOverlay> {
  double fps = 0;
  OverlayEntry? fpsOverlayEntry;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance!.addTimingsCallback((List<FrameTiming> timings) {
      double totalFrameTime = 0;
      for (FrameTiming timing in timings) {
        totalFrameTime += timing.totalSpan.inMicroseconds;
      }
      setState(() {
        fps = 100000000 / (totalFrameTime / timings.length);
      });
    });

    fpsOverlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        bottom: 16,
        right: 16,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'FPS: ${fps.toStringAsFixed(1)}',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    });

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Overlay.of(context)?.insert(fpsOverlayEntry!);
    });
  }

  @override
  void dispose() {
    fpsOverlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
