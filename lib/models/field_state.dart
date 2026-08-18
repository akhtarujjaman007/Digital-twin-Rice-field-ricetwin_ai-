enum FieldHealthStatus {
  healthy,
  warning,
  critical,
  offline,
}

class FieldState {
  final FieldHealthStatus status;
  final String message;
  final double environmentalRisk;

  const FieldState({
    required this.status,
    required this.message,
    required this.environmentalRisk,
  });

  factory FieldState.offline() {
    return const FieldState(
      status: FieldHealthStatus.offline,
      message: 'Backend is offline. No live field data available.',
      environmentalRisk: 0.0,
    );
  }
}