import 'package:flutter/material.dart';
import '../models/age_group_data.dart';

class InputFormViewModel extends ChangeNotifier {
  int _ageGroups = 3;
  late List<double> _birthRates;
  late List<double> _survivalRates;
  late List<double> _initialPopulation;
  int _yearsToPredict = 10;

  Map<String, String> _errors = {};

  int get ageGroups => _ageGroups;
  List<double> get birthRates => _birthRates;
  List<double> get survivalRates => _survivalRates;
  List<double> get initialPopulation => _initialPopulation;
  int get yearsToPredict => _yearsToPredict;
  Map<String, String> get errors => _errors;

  InputFormViewModel() {
    _reset();
  }

  void _reset() {
    _birthRates = List.filled(_ageGroups, 0.0);
    _survivalRates = List.filled(_ageGroups - 1, 0.5);
    _initialPopulation = List.filled(_ageGroups, 10.0);
  }

  void setAgeGroups(int value) {
    if (value == _ageGroups) return;
    _ageGroups = value.clamp(2, 10);
    _reset();
    _errors.clear();
    notifyListeners();
  }

  void setBirthRate(int index, double value) {
    if (index >= 0 && index < _birthRates.length) {
      _birthRates[index] = value;
      _validateBirthRates();
      notifyListeners();
    }
  }

  void setSurvivalRate(int index, double value) {
    if (index >= 0 && index < _survivalRates.length) {
      _survivalRates[index] = value.clamp(0, 1);
      _validateSurvivalRates();
      notifyListeners();
    }
  }

  void setInitialPopulation(int index, double value) {
    if (index >= 0 && index < _initialPopulation.length) {
      _initialPopulation[index] = value;
      _validatePopulation();
      notifyListeners();
    }
  }

  void setYearsToPredict(int value) {
    _yearsToPredict = value.clamp(1, 50);
    notifyListeners();
  }

  void _validateBirthRates() {
    if (_birthRates.any((rate) => rate < 0)) {
      _errors['birthRate'] = 'Birth rates cannot be negative';
    } else {
      _errors.remove('birthRate');
    }
  }

  void _validateSurvivalRates() {
    if (_survivalRates.any((rate) => rate < 0 || rate > 1)) {
      _errors['survivalRate'] = 'Survival rates must be between 0 and 1';
    } else {
      _errors.remove('survivalRate');
    }
  }

  void _validatePopulation() {
    if (_initialPopulation.any((pop) => pop < 0)) {
      _errors['population'] = 'Population cannot be negative';
    } else {
      _errors.remove('population');
    }
  }

  bool isValid() {
    _validateBirthRates();
    _validateSurvivalRates();
    _validatePopulation();
    return _errors.isEmpty;
  }

  AgeGroupData toAgeGroupData() {
    return AgeGroupData(
      ageGroups: _ageGroups,
      birthRates: List.from(_birthRates),
      survivalRates: List.from(_survivalRates),
      initialPopulation: List.from(_initialPopulation),
      yearsToPredict: _yearsToPredict,
    );
  }

  void loadSampleData() {
    _ageGroups = 3;
    _birthRates = [0.0, 2.0, 3.0];
    _survivalRates = [0.6, 0.5];
    _initialPopulation = [50.0, 30.0, 20.0];
    _yearsToPredict = 10;
    _errors.clear();
    notifyListeners();
  }
}
