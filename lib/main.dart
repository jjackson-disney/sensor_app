import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SensorData(),
    );
  }
}

class SensorData extends StatefulWidget {
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

