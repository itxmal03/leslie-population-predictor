import 'package:flutter/material.dart';
import 'package:leslie_predictor/models/population_result.dart';
import 'package:leslie_predictor/viewmodels/input_form_viewmodel.dart';
import 'package:leslie_predictor/viewmodels/leslie_calculator_viewmodel.dart';
import 'package:leslie_predictor/viewmodels/result_viewmodel.dart';
import 'package:provider/provider.dart';

class InputFormScreen extends StatefulWidget {
  const InputFormScreen({Key? key}) : super(key: key);

  @override
  State<InputFormScreen> createState() => _InputFormScreenState();
}

class _InputFormScreenState extends State<InputFormScreen> {
  late List<TextEditingController> _birthRateControllers;
  late List<TextEditingController> _initialPopControllers;
  int _previousAgeGroups = 0;

  @override
  void initState() {
    super.initState();
    _birthRateControllers = [];
    _initialPopControllers = [];
  }

  void _syncControllers(InputFormViewModel vm) {
    if (vm.ageGroups != _previousAgeGroups) {
      for (var c in _birthRateControllers) c.dispose();
      for (var c in _initialPopControllers) c.dispose();

      _birthRateControllers = List.generate(
        vm.ageGroups,
        (i) => TextEditingController(text: vm.birthRates[i].toStringAsFixed(2)),
      );
      _initialPopControllers = List.generate(
        vm.ageGroups,
        (i) => TextEditingController(
          text: vm.initialPopulation[i].toStringAsFixed(0),
        ),
      );
      _previousAgeGroups = vm.ageGroups;
    }
  }

  @override
  void dispose() {
    for (var c in _birthRateControllers) c.dispose();
    for (var c in _initialPopControllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Population Model Setup',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<InputFormViewModel>(
        builder: (context, vm, _) {
          _syncControllers(vm);
          return Column(
            children: [
              _buildProgressStrip(vm),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildAgeGroupsCard(vm),
                      const SizedBox(height: 14),
                      _buildBirthRatesCard(vm),
                      const SizedBox(height: 14),
                      _buildSurvivalRatesCard(vm),
                      const SizedBox(height: 14),
                      _buildInitialPopulationCard(vm),
                      const SizedBox(height: 14),
                      _buildYearsCard(vm),
                      const SizedBox(height: 14),
                      if (vm.errors.isNotEmpty) _buildErrorCard(vm),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              _buildStickyCalculateButton(context, vm),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressStrip(InputFormViewModel vm) {
    final total = vm.birthRates.fold<double>(0, (a, b) => a + b);
    final hasPopulation =
        vm.initialPopulation.fold<double>(0, (a, b) => a + b) > 0;
    final hasBirth = total > 0;
    final hasSurvival = vm.survivalRates.any((r) => r > 0);

    int steps = 0;
    if (hasBirth) steps++;
    if (hasSurvival) steps++;
    if (hasPopulation) steps++;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Text(
            'Setup Progress',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: steps / 3,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF4CAF50),
                ),
                minHeight: 4,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$steps/3',
            style: const TextStyle(
              color: Color(0xFF4CAF50),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    String subtitle,
    IconData icon, {
    String? tooltip,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF0A1628).withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF0A1628)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A1628),
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
        if (tooltip != null)
          Tooltip(
            message: tooltip,
            triggerMode: TooltipTriggerMode.tap,
            child: Icon(
              Icons.info_outline,
              size: 18,
              color: Colors.grey.shade400,
            ),
          ),
      ],
    );
  }

  Widget _buildAgeGroupsCard(InputFormViewModel vm) {
    return _buildCard(
      child: Column(
        children: [
          _buildSectionHeader(
            'Age Groups',
            'Select number of age groups',
            Icons.group_outlined,
            tooltip:
                'Age groups divide the population into stages. Each group has its own birth and survival rate.',
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(9, (index) {
              final value = index + 2;
              final selected = vm.ageGroups == value;
              return GestureDetector(
                onTap: () => vm.setAgeGroups(value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF0B3D4A)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF0B3D4A)
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$value',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: selected ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBirthRatesCard(InputFormViewModel vm) {
    return _buildCard(
      child: Column(
        children: [
          _buildSectionHeader(
            'Birth Rates',
            'Offspring per female per year',
            Icons.child_friendly_outlined,
            tooltip:
                'Birth rate is the average number of offspring produced per female in each age group per year.',
          ),
          const SizedBox(height: 16),
          ...List.generate(vm.ageGroups, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A1628).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Age ${i + 1}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0A1628),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _birthRateControllers[i],
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF0A1628),
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) =>
                          vm.setBirthRate(i, double.tryParse(value) ?? 0.0),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSurvivalRatesCard(InputFormViewModel vm) {
    return _buildCard(
      child: Column(
        children: [
          _buildSectionHeader(
            'Survival Rates',
            'Probability of surviving to next age group',
            Icons.favorite_outline,
            tooltip:
                'Survival rate is the probability (0 to 1) that an individual survives from one age group to the next.',
          ),
          const SizedBox(height: 16),
          ...List.generate(vm.ageGroups - 1, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Age ${i + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              Icons.arrow_forward,
                              size: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Age ${i + 2}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _getSurvivalColor(
                            vm.survivalRates[i],
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${(vm.survivalRates[i] * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getSurvivalColor(vm.survivalRates[i]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 7,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 14,
                      ),
                      activeTrackColor: _getSurvivalColor(vm.survivalRates[i]),
                      inactiveTrackColor: Colors.grey.shade200,
                      thumbColor: _getSurvivalColor(vm.survivalRates[i]),
                      overlayColor: _getSurvivalColor(
                        vm.survivalRates[i],
                      ).withOpacity(0.15),
                    ),
                    child: Slider(
                      value: vm.survivalRates[i],
                      min: 0,
                      max: 1,
                      divisions: 20,
                      onChanged: (value) => vm.setSurvivalRate(i, value),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getSurvivalColor(double value) {
    if (value >= 0.7) return const Color(0xFF2E7D32);
    if (value >= 0.4) return const Color(0xFFF57F17);
    return const Color(0xFFC62828);
  }

  Widget _buildInitialPopulationCard(InputFormViewModel vm) {
    final total = vm.initialPopulation.fold<double>(0, (a, b) => a + b);
    return _buildCard(
      child: Column(
        children: [
          _buildSectionHeader(
            'Initial Population',
            'Starting count per age group',
            Icons.people_outline,
            tooltip:
                'Enter the number of individuals in each age group at the start of the simulation.',
          ),
          const SizedBox(height: 16),
          ...List.generate(vm.ageGroups, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Age ${i + 1}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _initialPopControllers[i],
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF2E7D32),
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) => vm.setInitialPopulation(
                        i,
                        double.tryParse(value) ?? 0.0,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.07),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF2E7D32).withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Population',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                Text(
                  total.toStringAsFixed(0),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearsCard(InputFormViewModel vm) {
    return _buildCard(
      child: Column(
        children: [
          _buildSectionHeader(
            'Years to Predict',
            'Simulation duration',
            Icons.calendar_today_outlined,
            tooltip:
                'The number of years to project the population forward using the Leslie matrix.',
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Prediction Period',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B3D4A).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${vm.yearsToPredict} years',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF0B3D4A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: const Color(0xFF0B3D4A),
              inactiveTrackColor: Colors.grey.shade200,
              thumbColor: const Color(0xFF0B3D4A),
              overlayColor: const Color(0xFF0B3D4A).withOpacity(0.15),
            ),
            child: Slider(
              value: vm.yearsToPredict.toDouble(),
              min: 1,
              max: 50,
              divisions: 49,
              onChanged: (value) => vm.setYearsToPredict(value.toInt()),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1 yr',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
              ),
              Text(
                '50 yrs',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(InputFormViewModel vm) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFC62828).withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC62828).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.error_outline, size: 16, color: Color(0xFFC62828)),
              SizedBox(width: 8),
              Text(
                'Please fix the following',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC62828),
                  fontSize: 13,
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
                style: const TextStyle(fontSize: 12, color: Color(0xFFC62828)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyCalculateButton(
    BuildContext context,
    InputFormViewModel vm,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () {
            if (vm.isValid()) {
              _calculateAndNavigate(context, vm);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text('Please fix validation errors'),
                    ],
                  ),
                  backgroundColor: const Color(0xFFC62828),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0B3D4A),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calculate_rounded, size: 20),
              SizedBox(width: 10),
              Text(
                'Calculate Prediction',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
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
