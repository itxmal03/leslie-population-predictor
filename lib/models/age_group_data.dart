class AgeGroupData {
  final int ageGroups;
  final List<double> birthRates;
  final List<double> survivalRates;
  final List<double> initialPopulation;
  final int yearsToPredict;

  AgeGroupData({
    required this.ageGroups,
    required this.birthRates,
    required this.survivalRates,
    required this.initialPopulation,
    required this.yearsToPredict,
  });

  AgeGroupData copyWith({
    int? ageGroups,
    List<double>? birthRates,
    List<double>? survivalRates,
    List<double>? initialPopulation,
    int? yearsToPredict,
  }) {
    return AgeGroupData(
      ageGroups: ageGroups ?? this.ageGroups,
      birthRates: birthRates ?? this.birthRates,
      survivalRates: survivalRates ?? this.survivalRates,
      initialPopulation: initialPopulation ?? this.initialPopulation,
      yearsToPredict: yearsToPredict ?? this.yearsToPredict,
    );
  }
}
