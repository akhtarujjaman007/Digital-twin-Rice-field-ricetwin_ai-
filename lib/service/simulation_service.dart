import 'dart:math';

import '../models/sensor_data.dart';

class SimulationService {
  final Random _random =
      Random();

  double _temperature = 28;
  double _humidity = 75;
  double _soilMoisture = 70;
  double _waterLevel = 60;
  double _lightIntensity = 700;

  SensorData generateSensorData() {
    _temperature = _changeValue(
      _temperature,
      0.8,
      20,
      40,
    );

    _humidity = _changeValue(
      _humidity,
      2.5,
      40,
      100,
    );

    _soilMoisture = _changeValue(
      _soilMoisture,
      3,
      20,
      100,
    );

    _waterLevel = _changeValue(
      _waterLevel,
      2,
      0,
      100,
    );

    _lightIntensity = _changeValue(
      _lightIntensity,
      60,
      100,
      1200,
    );

    return SensorData(
      temperature: _temperature,
      humidity: _humidity,
      soilMoisture: _soilMoisture,
      waterLevel: _waterLevel,
      lightIntensity: _lightIntensity,
      timestamp: DateTime.now(),
    );
  }

  double _changeValue(
    double current,
    double variation,
    double minimum,
    double maximum,
  ) {
    final change =
        (_random.nextDouble() * 2 - 1) *
            variation;

    return (current + change).clamp(
      minimum,
      maximum,
    );
  }
}