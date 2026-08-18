import 'package:flutter/material.dart';

import '../models/field_state.dart';

class FieldVisualization
    extends StatelessWidget {
  final FieldState fieldState;

  const FieldVisualization({
    super.key,
    required this.fieldState,
  });

Color _getFieldColor() {
  switch (fieldState.status) {
    case FieldHealthStatus.healthy:
      return Colors.green;

    case FieldHealthStatus.warning:
      return Colors.orange;

    case FieldHealthStatus.critical:
      return Colors.red;

    case FieldHealthStatus.offline:
      return Colors.grey;
  }
}

String _getStatus() {
  switch (fieldState.status) {
    case FieldHealthStatus.healthy:
      return 'Healthy';

    case FieldHealthStatus.warning:
      return 'Warning';

    case FieldHealthStatus.critical:
      return 'Critical';

    case FieldHealthStatus.offline:
      return 'Offline';
  }
}

  @override
  Widget build(
    BuildContext context,
  ) {
    final color =
        _getFieldColor();

    return Container(
      height: 350,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(24),
        gradient: LinearGradient(
          begin:
              Alignment.topCenter,
          end:
              Alignment.bottomCenter,
          colors: [
            Colors.lightBlue.shade100,
            color.withOpacity(0.25),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 30,
            right: 40,
            child: Icon(
              Icons.wb_sunny,
              size: 60,
              color:
                  Colors.orange.shade300,
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.grass,
                  size: 120,
                  color: color,
                ),

                const SizedBox(
                  height: 15,
                ),

                Text(
                  'ZONE 1',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall,
                ),

                const SizedBox(
                  height: 8,
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration:
                      BoxDecoration(
                    color: color,
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: Text(
                    _getStatus(),
                    style:
                        const TextStyle(
                      color: Colors.white,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}