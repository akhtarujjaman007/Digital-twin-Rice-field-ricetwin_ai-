class SensorData {
  final double temperature;
  final double humidity;
  final double soilMoisture;
  final double waterLevel;
  final double lightIntensity;
  final DateTime timestamp;

  SensorData({
    required this.temperature,
    required this.humidity,
    required this.soilMoisture,
    required this.waterLevel,
    required this.lightIntensity,
    required this.timestamp,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      temperature:
          (json['temperature'] ?? 0).toDouble(),
      humidity:
          (json['humidity'] ?? 0).toDouble(),
      soilMoisture:
          (json['soilMoisture'] ?? 0).toDouble(),
      waterLevel:
          (json['waterLevel'] ?? 0).toDouble(),
      lightIntensity:
          (json['lightIntensity'] ?? 0).toDouble(),
      timestamp:
          DateTime.tryParse(
            json['timestamp']?.toString() ?? '',
          ) ??
          DateTime.now(),
    );
  }
}