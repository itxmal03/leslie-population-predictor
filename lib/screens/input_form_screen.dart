import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/input_form_viewmodel.dart';
import '../viewmodels/leslie_calculator_viewmodel.dart';
import '../viewmodels/result_viewmodel.dart';
import '../models/population_result.dart';

class InputFormScreen extends StatelessWidget {
  const InputFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Population Model Setup'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<InputFormViewModel>(
        builder: (context, formViewModel, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildAgeGroupsCard(formViewModel),
                const SizedBox(height: 16),
                _buildBirthRatesCard(formViewModel),
                const SizedBox(height: 16),
                _buildSurvivalRatesCard(formViewModel),
                const SizedBox(height: 16),
                _buildInitialPopulationCard(formViewModel),
                const SizedBox(height: 16),
                _buildYearsCard(formViewModel),
                const SizedBox(height: 24),
                if (formViewModel.errors.isNotEmpty)
                  _buildErrorCard(formViewModel),
                const SizedBox(height: 24),
                _buildCalculateButton(context, formViewModel),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAgeGroupsCard(InputFormViewModel vm) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Age Groups',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Number of age groups'),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${vm.ageGroups} groups',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Slider(
              value: vm.ageGroups.toDouble(),
              min: 2,
              max: 10,
              divisions: 8,
              onChanged: (value) => vm.setAgeGroups(value.toInt()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBirthRatesCard(InputFormViewModel vm) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Birth Rates',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Offspring per female per year',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ...List.generate(
              vm.ageGroups,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: Text('Age ${i + 1}')),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        initialValue: vm.birthRates[i].toStringAsFixed(2),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) =>
                            vm.setBirthRate(i, double.tryParse(value) ?? 0.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSurvivalRatesCard(InputFormViewModel vm) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Survival Rates',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Probability of surviving to next age group (0-1)',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ...List.generate(
              vm.ageGroups - 1,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Age ${i + 1} → Age ${i + 2}'),
                        Text(
                          vm.survivalRates[i].toStringAsFixed(2),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: vm.survivalRates[i],
                      min: 0,
                      max: 1,
                      divisions: 20,
                      onChanged: (value) => vm.setSurvivalRate(i, value),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialPopulationCard(InputFormViewModel vm) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Initial Population',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...List.generate(
              vm.ageGroups,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: Text('Age ${i + 1}')),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        initialValue: vm.initialPopulation[i].toStringAsFixed(
                          0,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) => vm.setInitialPopulation(
                          i,
                          double.tryParse(value) ?? 0.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Population:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    vm.initialPopulation
                        .fold<double>(0, (a, b) => a + b)
                        .toStringAsFixed(0),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearsCard(InputFormViewModel vm) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Years to Predict',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Prediction period'),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${vm.yearsToPredict} years',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Slider(
              value: vm.yearsToPredict.toDouble(),
              min: 1,
              max: 50,
              divisions: 49,
              onChanged: (value) => vm.setYearsToPredict(value.toInt()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(InputFormViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.error, size: 16, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'Validation Errors',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...vm.errors.values.map(
            (error) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '• $error',
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculateButton(BuildContext context, InputFormViewModel vm) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {
          if (vm.isValid()) {
            _calculateAndNavigate(context, vm);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please fix validation errors'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        icon: const Icon(Icons.calculate),
        label: const Text(
          'CALCULATE PREDICTION',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _calculateAndNavigate(BuildContext context, InputFormViewModel vm) {
    final calculatorVM = Provider.of<LeslieCalculatorViewModel>(
      context,
      listen: false,
    );
    final resultVM = Provider.of<ResultViewModel>(context, listen: false);

    calculatorVM.projectPopulation(
      vm.birthRates,
      vm.survivalRates,
      vm.initialPopulation,
      vm.yearsToPredict,
    );

    final lambda = calculatorVM.growthRate;
    String status = 'stable';
    if (lambda > 1.05) status = 'growing';
    if (lambda < 0.95) status = 'declining';

    final result = PopulationResult(
      leslieMatrix: calculatorVM.leslieMatrix,
      projectionHistory: calculatorVM.projectionHistory,
      growthRate: lambda,
      status: status,
      recommendation: '',
    );

    resultVM.setResult(result, vm.ageGroups);
    Navigator.pushNamed(context, '/result');
  }
}
