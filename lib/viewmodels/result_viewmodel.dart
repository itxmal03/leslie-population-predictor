import 'package:flutter/material.dart';
import '../models/population_result.dart';

class ResultViewModel extends ChangeNotifier {
  PopulationResult? _result;
  int _ageGroups = 0;

  PopulationResult? get result => _result;
  int get ageGroups => _ageGroups;

  void setResult(PopulationResult result, int ageGroups) {
    _result = result;
    _ageGroups = ageGroups;
    notifyListeners();
  }

  String getRecommendation() {
    if (_result == null) return '';
    final lambda = _result!.growthRate;
    if (lambda > 1.05) {
      return 'Population increases by ${((lambda - 1) * 100).toStringAsFixed(1)}% per year.\n'
          'Consider sustainable harvest quotas to manage growth.';
    } else if (lambda < 0.95) {
      return 'Population decreases by ${((1 - lambda) * 100).toStringAsFixed(1)}% per year.\n'
          'Conservation intervention needed to prevent extinction.';
    } else {
      return 'Population remains relatively stable.\n'
          'Minimal intervention required.';
    }
  }

  Color getStatusColor() {
    if (_result == null) return Colors.grey;
    final lambda = _result!.growthRate;
    if (lambda > 1.05) return Colors.green;
    if (lambda < 0.95) return Colors.red;
    return Colors.amber;
  }

  String getStatusText() {
    if (_result == null) return '';
    final lambda = _result!.growthRate;
    if (lambda > 1.05) return 'Growing';
    if (lambda < 0.95) return 'Declining';
    return 'Stable';
  }

  IconData getStatusIcon() {
    if (_result == null) return Icons.help_outline;
    final lambda = _result!.growthRate;
    if (lambda > 1.05) return Icons.trending_up;
    if (lambda < 0.95) return Icons.trending_down;
    return Icons.trending_flat;
  }
}
