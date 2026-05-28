import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../viewmodels/result_viewmodel.dart';
import '../models/population_result.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediction Results'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<ResultViewModel>(
        builder: (context, resultVM, _) {
          if (resultVM.result == null) {
            return const Center(child: Text('No data. Go back and calculate.'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildGrowthAnalysisCard(resultVM),
                const SizedBox(height: 20),
                _buildLeslieMatrixCard(resultVM.result!),
                const SizedBox(height: 20),
                _buildChartCard(resultVM.result!, resultVM.ageGroups),
                const SizedBox(height: 20),
                _buildProjectionTableCard(resultVM.result!),
                const SizedBox(height: 24),
                _buildActionButtons(context),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrowthAnalysisCard(ResultViewModel vm) {
    final color = vm.getStatusColor();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(vm.getStatusIcon(), size: 32, color: color),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Growth Rate', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(
                      'λ = ${vm.result!.growthRate.toStringAsFixed(3)}',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Population is ${vm.getStatusText()}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              vm.getRecommendation(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeslieMatrixCard(PopulationResult result) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Leslie Matrix', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 40,
                dataRowHeight: 40,
                columns: List.generate(
                  result.leslieMatrix.length,
                  (i) => DataColumn(label: Text('Col $i')),
                ),
                rows: List.generate(
                  result.leslieMatrix.length,
                  (i) => DataRow(
                    cells: List.generate(
                      result.leslieMatrix[i].length,
                      (j) => DataCell(
                        Text(
                          result.leslieMatrix[i][j].toStringAsFixed(2),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(PopulationResult result, int ageGroups) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.indigo,
      Colors.cyan,
    ];

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Population Trends', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(fontSize: 10)),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(fontSize: 10)),
                      ),
                    ),
                  ),
                  lineBarsData: List.generate(
                    ageGroups,
                    (ageIdx) => LineChartBarData(
                      spots: List.generate(
                        result.projectionHistory.length,
                        (year) => FlSpot(year.toDouble(), result.projectionHistory[year][ageIdx]),
                      ),
                      isCurved: false,
                      color: colors[ageIdx % colors.length],
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: List.generate(
                ageGroups,
                (i) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 12, height: 2, color: colors[i % colors.length]),
                    const SizedBox(width: 8),
                    Text('Age ${i + 1}', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectionTableCard(PopulationResult result) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Population Projection', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 40,
                dataRowHeight: 36,
                columns: [
                  const DataColumn(label: Text('Year')),
                  ...List.generate(result.projectionHistory[0].length, (i) => DataColumn(label: Text('Age${i + 1}'))),
                  const DataColumn(label: Text('Total')),
                ],
                rows: List.generate(
                  result.projectionHistory.length,
                  (year) => DataRow(
                    cells: [
                      DataCell(Text(year.toString())),
                      ...List.generate(
                        result.projectionHistory[year].length,
                        (age) => DataCell(
                          Text(
                            result.projectionHistory[year][age].toStringAsFixed(0),
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          result.projectionHistory[year].fold<double>(0, (a, b) => a + b).toStringAsFixed(0),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/input'),
            icon: const Icon(Icons.edit),
            label: const Text('Edit'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            icon: const Icon(Icons.home),
            label: const Text('Home'),
          ),
        ),
      ],
    );
  }
}