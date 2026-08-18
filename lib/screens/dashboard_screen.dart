import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/field_state.dart';
import '../providers/digital_twin_provider.dart';
import '../widgets/status_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DigitalTwinProvider>(
      builder: (context, provider, child) {
        String fieldStatus;
        Color statusColor;

        switch (provider.fieldState.status) {
  case FieldHealthStatus.healthy:
    fieldStatus = 'Healthy';
    statusColor = Colors.green;
    break;

  case FieldHealthStatus.warning:
    fieldStatus = 'Warning';
    statusColor = Colors.orange;
    break;

  case FieldHealthStatus.critical:
    fieldStatus = 'Critical';
    statusColor = Colors.red;
    break;

  case FieldHealthStatus.offline:
    fieldStatus = 'Offline';
    statusColor = Colors.grey;
    break;
}

        final diseaseAnalyzed =
            provider.diseaseResult.confidence > 0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rice Field Dashboard',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 5),

              const Text(
                'Zone 1 • Digital Twin Overview',
              ),

              const SizedBox(height: 24),

              // ==================================================
              // SYSTEM STATUS
              // ==================================================

              Text(
                'System Status',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 14),

              StatusCard(
                title: 'Digital Twin Status',
                value: fieldStatus,
                icon: Icons.sensors,
                color: statusColor,
              ),

              const SizedBox(height: 10),

              StatusCard(
                title: 'AI Disease Status',
                value: diseaseAnalyzed
                    ? provider.diseaseResult.disease
                    : 'Not analyzed',
                icon: Icons.biotech,
                color: !diseaseAnalyzed
                    ? Colors.grey
                    : provider.diseaseResult.isHealthy
                        ? Colors.green
                        : Colors.orange,
              ),

              const SizedBox(height: 10),

              StatusCard(
                title: 'AI Backend',
                value: provider.backendConnected
                    ? 'Connected'
                    : 'Disconnected',
                icon: Icons.cloud,
                color: provider.backendConnected
                    ? Colors.green
                    : Colors.red,
              ),

              const SizedBox(height: 30),

              // ==================================================
              // RISK ANALYSIS
              // ==================================================

              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Risk Analysis',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      fieldStatus.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              _RiskCard(
                title: 'Environmental Risk',
                subtitle: 'Based on current field sensor conditions',
                risk: provider.environmentalRisk,
                icon: Icons.eco,
              ),

              const SizedBox(height: 12),

              _RiskCard(
                title: 'AI Disease Risk',
                subtitle: diseaseAnalyzed
                    ? 'Based on ${provider.diseaseResult.disease} prediction'
                    : 'Upload a rice image for AI analysis',
                risk: provider.diseaseRisk,
                icon: Icons.biotech,
              ),

              const SizedBox(height: 12),

              _RiskCard(
                title: 'Combined Risk',
                subtitle: 'Combined digital twin risk assessment',
                risk: provider.overallRisk,
                icon: Icons.analytics,
                highlighted: true,
              ),

              const SizedBox(height: 20),

              // ==================================================
              // RECOMMENDATION
              // ==================================================

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: statusColor,
                        size: 30,
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Digital Twin Recommendation',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              provider.fieldState.message,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ================================================================
// RISK CARD
// ================================================================

class _RiskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double risk;
  final IconData icon;
  final bool highlighted;

  const _RiskCard({
    required this.title,
    required this.subtitle,
    required this.risk,
    required this.icon,
    this.highlighted = false,
  });

  Color _getRiskColor() {
    if (risk < 35) {
      return Colors.green;
    }

    if (risk < 70) {
      return Colors.orange;
    }

    return Colors.red;
  }

  String _getRiskLevel() {
    if (risk < 35) {
      return 'Low';
    }

    if (risk < 70) {
      return 'Moderate';
    }

    return 'High';
  }

  @override
  Widget build(BuildContext context) {
    final color = _getRiskColor();

    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: highlighted
            ? BoxDecoration(
                border: Border.all(
                  color: color.withOpacity(0.4),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(18),
              )
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.12),
                  child: Icon(
                    icon,
                    color: color,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${risk.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),

                    Text(
                      _getRiskLevel(),
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 18),

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: risk,
                minHeight: 12,
                backgroundColor: color.withOpacity(0.12),
                valueColor: AlwaysStoppedAnimation<Color>(
                  color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}