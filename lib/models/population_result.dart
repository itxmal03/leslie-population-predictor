class PopulationResult {
  final List<List<double>> leslieMatrix;
  final List<List<double>> projectionHistory;
  final double growthRate;
  final String status;
  final String recommendation;

  PopulationResult({
    required this.leslieMatrix,
    required this.projectionHistory,
    required this.growthRate,
    required this.status,
    required this.recommendation,
  });
}
