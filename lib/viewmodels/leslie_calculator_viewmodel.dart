import 'package:flutter/material.dart';

class LeslieCalculatorViewModel extends ChangeNotifier {
  List<List<double>> _leslieMatrix = [];
  List<List<double>> _projectionHistory = [];
  double _growthRate = 0.0;

  List<List<double>> get leslieMatrix => _leslieMatrix;
  List<List<double>> get projectionHistory => _projectionHistory;
  double get growthRate => _growthRate;

  void buildLeslieMatrix(List<double> birthRates, List<double> survivalRates) {
    int n = birthRates.length;
    _leslieMatrix = List.generate(n, (_) => List.filled(n, 0.0));

    // First row = birth rates
    for (int j = 0; j < n; j++) {
      _leslieMatrix[0][j] = birthRates[j];
    }

    // Sub-diagonal = survival rates
    for (int i = 0; i < n - 1; i++) {
      _leslieMatrix[i + 1][i] = survivalRates[i];
    }

    notifyListeners();
  }

  void projectPopulation(
    List<double> birthRates,
    List<double> survivalRates,
    List<double> initialPopulation,
    int years,
  ) {
    buildLeslieMatrix(birthRates, survivalRates);

    int n = initialPopulation.length;
    _projectionHistory = [];
    _projectionHistory.add(List.from(initialPopulation));

    List<double> current = List.from(initialPopulation);
    for (int year = 0; year < years; year++) {
      List<double> next = List.filled(n, 0.0);
      for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
          next[i] += _leslieMatrix[i][j] * current[j];
        }
      }
      current = next;
      _projectionHistory.add(List.from(current));
    }

    _growthRate = _computeGrowthRate();
    notifyListeners();
  }

  double _computeGrowthRate() {
    int n = _leslieMatrix.length;
    List<double> v = List.filled(n, 1.0);

    for (int iter = 0; iter < 100; iter++) {
      List<double> newV = List.filled(n, 0.0);
      for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
          newV[i] += _leslieMatrix[i][j] * v[j];
        }
      }

      double sumOld = v.fold<double>(0, (a, b) => a + b);
      double sumNew = newV.fold<double>(0, (a, b) => a + b);

      if (sumOld == 0) return 1.0;
      double ratio = sumNew / sumOld;

      if (iter == 99) return ratio;
      v = newV;
    }
    return 1.0;
  }
}
