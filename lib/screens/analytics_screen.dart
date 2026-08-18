import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/digital_twin_provider.dart';

class AnalyticsScreen
    extends StatelessWidget {
  const AnalyticsScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Consumer<
        DigitalTwinProvider>(
      builder: (
        context,
        provider,
        child,
      ) {
        final history =
            provider.history;

        return SingleChildScrollView(
          padding:
              const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Sensor Analytics',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium,
              ),

              const SizedBox(
                height: 20,
              ),

              _chart(
                title:
                    'Temperature °C',
                values: history
                    .map(
                      (data) =>
                          data.temperature,
                    )
                    .toList(),
              ),

              const SizedBox(
                height: 20,
              ),

              _chart(
                title: 'Humidity %',
                values: history
                    .map(
                      (data) =>
                          data.humidity,
                    )
                    .toList(),
              ),

              const SizedBox(
                height: 20,
              ),

              _chart(
                title:
                    'Soil Moisture %',
                values: history
                    .map(
                      (data) =>
                          data.soilMoisture,
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _chart({
    required String title,
    required List<double> values,
  }) {
    final displayValues =
        values.length > 30
            ? values.sublist(
                values.length - 30,
              )
            : values;

    final spots =
        List.generate(
      displayValues.length,
      (index) => FlSpot(
        index.toDouble(),
        displayValues[index],
      ),
    );

    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:
                  const TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            SizedBox(
              height: 250,
              child: spots.isEmpty
                  ? const Center(
                      child: Text(
                        'Waiting for sensor data...',
                      ),
                    )
                  : LineChart(
                      LineChartData(
                        gridData:
                            const FlGridData(
                          show: true,
                        ),
                        titlesData:
                            const FlTitlesData(
                          topTitles:
                              AxisTitles(
                            sideTitles:
                                SideTitles(
                              showTitles:
                                  false,
                            ),
                          ),
                          rightTitles:
                              AxisTitles(
                            sideTitles:
                                SideTitles(
                              showTitles:
                                  false,
                            ),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved:
                                true,
                            dotData:
                                const FlDotData(
                              show:
                                  false,
                            ),
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