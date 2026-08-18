import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/digital_twin_provider.dart';
import '../service/api_service.dart';

class DigitalTwinScreen extends StatelessWidget {
  const DigitalTwinScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DigitalTwinProvider>(
      builder: (context, provider, child) {
        // =====================================================
        // BACKEND OFFLINE
        // =====================================================

        if (!provider.backendConnected ||
            provider.currentSensorData == null) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cloud_off,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Digital Twin Offline',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Start the RiceTwin backend to receive '
                    'live sensor data and synchronize the '
                    'digital twin.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        // =====================================================
        // BACKEND DATA
        // =====================================================

        final sensor = provider.currentSensorData!;
        final crop = provider.cropState;
        final prediction = provider.predictionState;
        final recommendation = provider.recommendation;

        return RefreshIndicator(
          onRefresh: provider.refresh,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // =================================================
              // PAGE HEADER
              // =================================================

              Text(
                'Zone 1 Digital Twin',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium,
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  const Icon(
                    Icons.sync,
                    size: 18,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Synchronization: '
                    '${provider.synchronizationStatus}',
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // =================================================
              // LIVE SENSOR DATA
              // =================================================

              const Text(
                'Live Field Monitoring',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _metric(
                    'Temperature',
                    sensor.temperature,
                    '°C',
                    Icons.thermostat,
                  ),
                  _metric(
                    'Humidity',
                    sensor.humidity,
                    '%',
                    Icons.water_drop_outlined,
                  ),
                  _metric(
                    'Soil Moisture',
                    sensor.soilMoisture,
                    '%',
                    Icons.grass,
                  ),
                  _metric(
                    'Water Level',
                    sensor.waterLevel,
                    '%',
                    Icons.water,
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // =================================================
              // ESP32-CAM IMAGE
              // =================================================

              if (provider.latestCameraImage != null) ...[
                const Text(
                  'Latest ESP32-CAM Capture',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          ApiService.imageUrl(
                            provider.latestCameraImage!,
                          ),
                          fit: BoxFit.cover,
                          errorBuilder: (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return const Center(
                              child: Column(
                                mainAxisSize:
                                    MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.broken_image_outlined,
                                    size: 50,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Camera image unavailable',
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      ListTile(
                        leading: Icon(
                          provider.diseaseResult.isHealthy
                              ? Icons.check_circle
                              : Icons.warning_rounded,
                          color:
                              provider.diseaseResult.isHealthy
                                  ? Colors.green
                                  : Colors.orange,
                        ),
                        title: const Text(
                          'Latest ESP32-CAM Diagnosis',
                        ),
                        subtitle: Text(
                          '${provider.diseaseResult.disease} • '
                          '${provider.diseaseResult.confidencePercent.toStringAsFixed(1)}%',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],

              // =================================================
              // CROP DIGITAL STATE
              // =================================================

              if (crop != null) ...[
                const Text(
                  'Crop Digital State',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.grass,
                      size: 35,
                    ),
                    title: Text(
                      'Growth Stage: ${crop.growthStage}',
                    ),
                    subtitle: Text(
                      '${crop.variety}\n'
                      'Day ${crop.daysAfterPlanting}\n'
                      'Planted: ${crop.plantingDate}',
                    ),
                    isThreeLine: true,
                  ),
                ),

                const SizedBox(height: 20),
              ],

              // =================================================
              // PREDICTIVE DIGITAL TWIN
              // =================================================

              if (prediction != null) ...[
                const Text(
                  'Predictive Field State',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.analytics_outlined,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Soil Moisture Forecast',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        _predictionRow(
                          'Current',
                          prediction.current,
                        ),

                        _predictionRow(
                          'After 1 hour',
                          prediction.after1Hour,
                        ),

                        _predictionRow(
                          'After 3 hours',
                          prediction.after3Hours,
                        ),

                        _predictionRow(
                          'After 6 hours',
                          prediction.after6Hours,
                        ),

                        if (prediction
                            .irrigationRequired) ...[
                          const SizedBox(height: 15),

                          Container(
                            width: double.infinity,
                            padding:
                                const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange
                                  .withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.warning_amber,
                                  color: Colors.orange,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Irrigation is predicted '
                                    'to be required.',
                                    style: TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],

              // =================================================
              // ACTUATOR CONTROL
              // =================================================

              const Text(
                'Actuator Control',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Card(
                child: SwitchListTile(
                  secondary: const Icon(
                    Icons.water_drop,
                  ),
                  title: const Text(
                    'Irrigation Pump',
                  ),
                  subtitle: Text(
                    'Current state: '
                    '${provider.actuatorState?.pump ?? 'OFF'}',
                  ),
                  value:
                      provider.actuatorState?.pump == 'ON',
                  onChanged: (value) {
                    provider.setPump(value);
                  },
                ),
              ),

              const SizedBox(height: 20),

              // =================================================
              // INTELLIGENT RECOMMENDATION
              // =================================================

              if (recommendation != null) ...[
                const Text(
                  'Intelligent Recommendation',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.lightbulb_outline,
                      size: 35,
                    ),
                    title: Text(
                      recommendation.title,
                    ),
                    subtitle: Text(
                      recommendation.message,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],

              // =================================================
              // SIMULATION CONTROLS
              // =================================================

              const Divider(),

              const SizedBox(height: 10),

              const Text(
                'Research Prototype Controls',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'These controls simulate the physical IoT '
                'devices during prototype testing.',
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed:
                          provider.simulateSensorUpdate,
                      icon: const Icon(
                        Icons.sensors,
                      ),
                      label: const Text(
                        'New Sensor Reading',
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          provider.analyzingImage
                              ? null
                              : provider
                                  .simulateCameraCapture,
                      icon: provider.analyzingImage
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt,
                            ),
                      label: Text(
                        provider.analyzingImage
                            ? 'Analyzing...'
                            : 'Capture + AI',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  // ==========================================================
  // SENSOR METRIC CARD
  // ==========================================================

  Widget _metric(
    String title,
    double value,
    String unit,
    IconData icon,
  ) {
    return SizedBox(
      width: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 30,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                '${value.toStringAsFixed(1)}$unit',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // PREDICTION ROW
  // ==========================================================

  Widget _predictionRow(
    String title,
    double value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(title),
          ),
          Text(
            '${value.toStringAsFixed(1)}%',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}