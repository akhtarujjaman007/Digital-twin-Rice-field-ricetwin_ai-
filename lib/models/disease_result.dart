class TopPrediction {
  final String disease;
  final double confidence;
  final double confidencePercent;

  const TopPrediction({
    required this.disease,
    required this.confidence,
    required this.confidencePercent,
  });

  factory TopPrediction.fromJson(
    Map<String, dynamic> json,
  ) {
    final double confidence =
        (json['confidence'] ?? 0).toDouble();

    return TopPrediction(
      disease:
          json['class']?.toString() ??
          json['disease']?.toString() ??
          'Unknown',
      confidence: confidence,
      confidencePercent:
          (json['confidence_percent'] ??
                  confidence * 100)
              .toDouble(),
    );
  }
}


class DiseaseResult {
  final String disease;

  final double confidence;

  final bool isHealthy;

  final List<TopPrediction>
      topPredictions;

  final String? image;

  final DateTime? timestamp;


  const DiseaseResult({
    required this.disease,
    required this.confidence,
    required this.isHealthy,
    this.topPredictions = const [],
    this.image,
    this.timestamp,
  });


  double get confidencePercent =>
      confidence * 100;


  factory DiseaseResult.empty() {
    return const DiseaseResult(
      disease: 'No Diagnosis',
      confidence: 0.0,
      isHealthy: false,
      topPredictions: [],
    );
  }


  factory DiseaseResult.fromJson(
    Map<String, dynamic> json,
  ) {
    final String disease =
        json['disease']?.toString() ??
        'Unknown';


    final double confidence =
        (json['confidence'] ?? 0)
            .toDouble();


    final dynamic rawPredictions =
        json['top_predictions'];


    final List<TopPrediction>
        predictions = [];


    if (rawPredictions is List) {
      for (final item
          in rawPredictions) {
        if (item is Map) {
          predictions.add(
            TopPrediction.fromJson(
              Map<String, dynamic>.from(
                item,
              ),
            ),
          );
        }
      }
    }


    return DiseaseResult(
      disease:
          disease,

      confidence:
          confidence,

      isHealthy:
          json['is_healthy'] ??
          json['isHealthy'] ??
          disease
                  .toLowerCase()
                  .trim() ==
              'healthy',

      topPredictions:
          predictions,

      image:
          json['image']
              ?.toString(),

      timestamp:
          json['timestamp'] != null
              ? DateTime.tryParse(
                  json['timestamp']
                      .toString(),
                )
              : null,
    );
  }
}