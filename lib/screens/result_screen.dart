import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:leslie_predictor/models/population_result.dart';
import 'package:leslie_predictor/viewmodels/result_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _lambdaController;
  late AnimationController _cardController;
  late Animation<double> _lambdaAnimation = AlwaysStoppedAnimation(0.0);
  late Animation<double> _cardFadeAnimation;
  late Animation<Offset> _cardSlideAnimation;

  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();

    _lambdaController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _cardFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _cardController, curve: Curves.easeIn));

    _cardSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _cardController, curve: Curves.easeOut));

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        final vm = Provider.of<ResultViewModel>(context, listen: false);
        if (vm.result != null) {
          _lambdaAnimation =
              Tween<double>(begin: 0.0, end: vm.result!.growthRate).animate(
                CurvedAnimation(
                  parent: _lambdaController,
                  curve: Curves.easeOut,
                ),
              );
          _lambdaController.forward();
          _cardController.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    _lambdaController.dispose();
    _cardController.dispose();
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
          'Prediction Results',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: () => _showShareOptions(context),
          ),
        ],
      ),
      body: Consumer<ResultViewModel>(
        builder: (context, vm, _) {
          if (vm.result == null) {
            return const Center(child: Text('No data. Go back and calculate.'));
          }
          return FadeTransition(
            opacity: _cardFadeAnimation,
            child: SlideTransition(
              position: _cardSlideAnimation,
              child: Screenshot(
                controller: _screenshotController,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildGrowthCard(context, vm),
                      const SizedBox(height: 14),
                      _buildSummaryStatsRow(vm),
                      const SizedBox(height: 14),
                      _buildDonutChartCard(vm),
                      const SizedBox(height: 14),
                      _buildLineChartCard(vm),
                      const SizedBox(height: 14),
                      _buildLeslieMatrixCard(vm.result!),
                      const SizedBox(height: 14),
                      _buildProjectionTableCard(vm.result!),
                      const SizedBox(height: 14),
                      _buildActionButtons(context),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGrowthCard(BuildContext context, ResultViewModel vm) {
    final color = vm.getStatusColor();
    final status = vm.getStatusText();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A1628), Color(0xFF0B3D4A)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A1628).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Text(
              'λ',
              style: TextStyle(
                fontSize: 120,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: color.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(vm.getStatusIcon(), color: color, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Growth Rate (λ)',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _lambdaController,
                        builder: (context, _) {
                          final val = _lambdaAnimation.value;
                          return Text(
                            'λ = ${val.toStringAsFixed(3)}',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Text(
                  'Population is ${status.toUpperCase()}',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                vm.getRecommendation(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStatsRow(ResultViewModel vm) {
    final history = vm.result!.projectionHistory;
    final initialTotal = history.first.fold<double>(0, (a, b) => a + b);
    final finalTotal = history.last.fold<double>(0, (a, b) => a + b);

    // Smart change formatting
    String changeText;
    if (initialTotal == 0) {
      changeText = 'N/A';
    } else {
      final change = ((finalTotal - initialTotal) / initialTotal * 100);
      if (change.abs() >= 10000) {
        changeText =
            '${change >= 0 ? '+' : ''}${(change / 1000).toStringAsFixed(1)}K%';
      } else if (change.abs() >= 1000) {
        changeText = '${change >= 0 ? '+' : ''}${change.toStringAsFixed(0)}%';
      } else {
        changeText = '${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)}%';
      }
    }

    final rawChange = initialTotal == 0
        ? 0.0
        : (finalTotal - initialTotal) / initialTotal * 100;
    final isPositive = rawChange >= 0;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            label: 'Initial Pop.',
            value: _formatNumber(initialTotal),
            icon: Icons.people_outline,
            color: const Color(0xFF1565C0),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            label: 'Final Pop.',
            value: _formatNumber(finalTotal),
            icon: Icons.people,
            color: const Color(0xFF0B3D4A),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            label: 'Change',
            value: changeText,
            icon: initialTotal == 0
                ? Icons.remove
                : isPositive
                ? Icons.trending_up
                : Icons.trending_down,
            color: initialTotal == 0
                ? Colors.grey
                : isPositive
                ? const Color(0xFF2E7D32)
                : const Color(0xFFC62828),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildDonutChartCard(ResultViewModel vm) {
    final finalYear = vm.result!.projectionHistory.last;
    final total = finalYear.fold<double>(0, (a, b) => a + b);
    final colors = _chartColors();
    final isEmpty = total == 0;

    return _buildCard(
      title: 'Final Year Age Distribution',
      subtitle: 'Population breakdown at end of projection',
      icon: Icons.donut_large_outlined,
      child: Column(
        children: [
          SizedBox(
            height: 220,
            child: isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.donut_large_outlined,
                          size: 52,
                          color: Colors.grey.shade200,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No population data to display',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Enter population values to see distribution',
                          style: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  )
                : PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 55,
                      sections: List.generate(finalYear.length, (i) {
                        final percent = finalYear[i] / total * 100;
                        return PieChartSectionData(
                          value: finalYear[i],
                          color: colors[i % colors.length],
                          radius: 36,
                          showTitle: percent > 5,
                          title: '${percent.toStringAsFixed(0)}%',
                          titleStyle: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }),
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: List.generate(finalYear.length, (i) {
              final percent = total > 0
                  ? (finalYear[i] / total * 100).toStringAsFixed(1)
                  : '0.0';
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: colors[i % colors.length],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Age ${i + 1} ($percent%)',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChartCard(ResultViewModel vm) {
    final colors = _chartColors();
    final history = vm.result!.projectionHistory;

    double maxVal = 0;
    for (final row in history) {
      for (final v in row) {
        if (v > maxVal) maxVal = v;
      }
    }

    // Dynamic reserved size based on formatted label width
    final longestLabel = _formatNumber(maxVal);
    final yReservedSize = (longestLabel.length * 8.0 + 12).clamp(52.0, 80.0);

    return _buildCard(
      title: 'Population Trends',
      subtitle: 'Age group projections over time (Y: Population)',
      icon: Icons.show_chart_rounded,
      child: Column(
        children: [
          SizedBox(
            height: 260,
            child: Padding(
              padding: const EdgeInsets.only(right: 12, top: 8),
              child: LineChart(
                LineChartData(
                  clipData: const FlClipData.all(),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) =>
                        FlLine(color: Colors.grey.shade100, strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Text(
                        'Year',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      axisNameSize: 24,
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 24,
                        interval: history.length > 20
                            ? (history.length / 5).roundToDouble()
                            : 2,
                        getTitlesWidget: (value, meta) {
                          // Hide first and last to avoid edge overlap
                          if (value == meta.min || value == meta.max) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: yReservedSize,
                        getTitlesWidget: (value, meta) {
                          // Only hide exact min and max — show everything in between
                          if (value == meta.min || value == meta.max) {
                            return const SizedBox.shrink();
                          }
                          return SizedBox(
                            width: yReservedSize - 4,
                            child: Text(
                              _formatNumber(value),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: List.generate(
                    vm.ageGroups,
                    (ageIdx) => LineChartBarData(
                      spots: List.generate(
                        history.length,
                        (year) =>
                            FlSpot(year.toDouble(), history[year][ageIdx]),
                      ),
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: colors[ageIdx % colors.length],
                      barWidth: 1.5,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: colors[ageIdx % colors.length].withOpacity(0.03),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 14,
            runSpacing: 8,
            children: List.generate(
              vm.ageGroups,
              (i) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 2,
                    decoration: BoxDecoration(
                      color: colors[i % colors.length],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Age ${i + 1}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeslieMatrixCard(PopulationResult result) {
    return _buildCard(
      title: 'Leslie Matrix',
      subtitle: 'Age-structured transition matrix',
      icon: Icons.grid_on_rounded,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          defaultColumnWidth: const FixedColumnWidth(64),
          border: TableBorder(
            horizontalInside: BorderSide(color: Colors.grey.shade100, width: 1),
            verticalInside: BorderSide(color: Colors.grey.shade100, width: 1),
          ),
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: const Color(0xFF0A1628).withOpacity(0.05),
              ),
              children: List.generate(
                result.leslieMatrix.length + 1,
                (j) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  child: Text(
                    j == 0 ? '' : 'C$j',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A1628),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            ...List.generate(result.leslieMatrix.length, (i) {
              return TableRow(
                decoration: BoxDecoration(
                  color: i.isEven ? Colors.white : Colors.grey.shade50,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 4,
                    ),
                    child: Text(
                      'R${i + 1}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A1628),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ...List.generate(result.leslieMatrix[i].length, (j) {
                    final val = result.leslieMatrix[i][j];
                    final isHighlight = (i == 0) || (j == i - 1);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      child: Container(
                        decoration: isHighlight && val > 0
                            ? BoxDecoration(
                                color: i == 0
                                    ? const Color(0xFF1565C0).withOpacity(0.1)
                                    : const Color(0xFF2E7D32).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              )
                            : null,
                        child: Text(
                          val.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isHighlight && val > 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isHighlight && val > 0
                                ? (i == 0
                                      ? const Color(0xFF1565C0)
                                      : const Color(0xFF2E7D32))
                                : Colors.grey.shade400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectionTableCard(PopulationResult result) {
    return _buildCard(
      title: 'Population Projection',
      subtitle: 'Year-by-year breakdown',
      icon: Icons.table_chart_outlined,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 36,
          dataRowHeight: 32,
          headingRowColor: WidgetStateProperty.all(
            const Color(0xFF0A1628).withOpacity(0.05),
          ),
          columns: [
            const DataColumn(
              label: Text(
                'Year',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Color(0xFF0A1628),
                ),
              ),
            ),
            ...List.generate(
              result.projectionHistory[0].length,
              (i) => DataColumn(
                label: Text(
                  'Age${i + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Color(0xFF0A1628),
                  ),
                ),
              ),
            ),
            const DataColumn(
              label: Text(
                'Total',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Color(0xFF0A1628),
                ),
              ),
            ),
          ],
          rows: List.generate(result.projectionHistory.length, (year) {
            final rowTotal = result.projectionHistory[year].fold<double>(
              0,
              (a, b) => a + b,
            );
            return DataRow(
              color: WidgetStateProperty.resolveWith(
                (states) => year.isEven ? Colors.white : Colors.grey.shade50,
              ),
              cells: [
                DataCell(
                  Text(
                    year.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      color: Color(0xFF0A1628),
                    ),
                  ),
                ),
                ...List.generate(
                  result.projectionHistory[year].length,
                  (age) => DataCell(
                    Text(
                      result.projectionHistory[year][age].toStringAsFixed(0),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    _formatNumber(rowTotal),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/input'),
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Edit Inputs'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0B3D4A),
              side: const BorderSide(color: Color(0xFF0B3D4A)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            icon: const Icon(Icons.home_outlined, size: 18),
            label: const Text('Home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0B3D4A),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Export Results',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1565C0).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.download_outlined,
                  color: Color(0xFF1565C0),
                ),
              ),
              title: const Text('Save Screenshot'),
              subtitle: const Text('Save results as image to gallery'),
              onTap: () async {
                Navigator.pop(ctx);
                try {
                  final image = await _screenshotController.capture(
                    pixelRatio: 2.0,
                  );
                  if (image != null) {
                    await ImageGallerySaverPlus.saveImage(
                      image,
                      name:
                          'leslie_result_${DateTime.now().millisecondsSinceEpoch}',
                    );

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text('Saved to gallery!'),
                            ],
                          ),
                          backgroundColor: const Color(0xFF2E7D32),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Could not save screenshot'),
                        backgroundColor: const Color(0xFFC62828),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget child,
  }) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFF0A1628).withOpacity(0.07),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 17, color: const Color(0xFF0A1628)),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A1628),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  List<Color> _chartColors() => [
    const Color(0xFF1565C0),
    const Color(0xFF00BCD4),
    const Color(0xFF2E7D32),
    const Color(0xFF6A1B9A),
    const Color(0xFFE65100),
    const Color(0xFFC62828),
    const Color(0xFF00838F),
    const Color(0xFF558B2F),
    const Color(0xFF4527A0),
    const Color(0xFF37474F),
  ];

  String _formatNumber(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toStringAsFixed(0);
  }
}
