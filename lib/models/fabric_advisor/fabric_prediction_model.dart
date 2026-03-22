class FabricPrediction {
  final String? fabric;
  final double? confidence;
  final String? predictionSource;
  final String? washType;
  final String? washCycle;
  final String? waterTemperature;
  final String? detergent;
  final String? drying;
  final String? ironing;
  final List<String>? careTips;
  final List<String>? warnings;
  final String? advisory;
  final String? textDescription;

  FabricPrediction({
    this.fabric,
    this.confidence,
    this.predictionSource,
    this.washType,
    this.washCycle,
    this.waterTemperature,
    this.detergent,
    this.drying,
    this.ironing,
    this.careTips,
    this.warnings,
    this.advisory,
    this.textDescription,
  });

  factory FabricPrediction.fromJson(Map<String, dynamic> json) {
    return FabricPrediction(
      fabric: json['fabric'] as String?,
      confidence: json['confidence'] != null ? (json['confidence'] as num).toDouble() : null,
      predictionSource: json['prediction_source'] as String?,
      washType: json['wash_type'] as String?,
      washCycle: json['wash_cycle'] as String?,
      waterTemperature: json['water_temperature'] as String?,
      detergent: json['detergent'] as String?,
      drying: json['drying'] as String?,
      ironing: json['ironing'] as String?,
      careTips: json['care_tips'] != null ? List<String>.from(json['care_tips']) : null,
      warnings: json['warnings'] != null ? List<String>.from(json['warnings']) : null,
      advisory: json['advisory'] as String?,
      textDescription: json['text_description'] as String?,
    );
  }
}
