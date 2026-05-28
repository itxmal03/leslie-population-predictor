import 'package:flutter/material.dart';
import 'package:leslie_predictor/viewmodels/input_form_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Leslie Predictor',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroBanner(context),
            _buildQuickStatsRow(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A1628),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPrimaryCard(context),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSecondaryCard(
                          context,
                          icon: Icons.nature,
                          title: 'Sample',
                          subtitle: 'Deer population\nexample',
                          color: const Color(0xFF2E7D32),
                          onTap: () => _loadSampleAndNavigate(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSecondaryCard(
                          context,
                          icon: Icons.auto_stories_outlined,
                          title: 'About',
                          subtitle: 'Learn the\nmath behind it',
                          color: const Color(0xFF6A1B9A),
                          onTap: () => _showAboutDialog(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildInfoStrip(),
                  const SizedBox(height: 20),
                  _buildBottomBranding(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A1628), Color(0xFF0D2137), Color(0xFF0B3D4A)],
        ),
      ),
      child: Stack(
        children: [
          // Faded lambda background
          Positioned(
            right: -10,
            top: -20,
            child: Text(
              'λ',
              style: TextStyle(
                fontSize: 160,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),

          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00BCD4).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF00BCD4).withOpacity(0.3),
                        ),
                      ),
                      child: const Text(
                        'λ · Leslie Matrix',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF00BCD4),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Population\nGrowth\nPredictor',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Age-structured modeling\nfor ecology & conservation',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.55),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Decorative donut chart
              Expanded(flex: 2, child: _buildDecorativeDonut()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeDonut() {
    return SizedBox(
      width: 110,
      height: 110,
      child: CustomPaint(
        painter: _DonutPainter(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'λ',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'growth',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStatsRow() {
    return Container(
      color: const Color(0xFF0B3D4A),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('10', 'Age Groups'),
          _buildStatDivider(),
          _buildStatItem('50', 'Max Years'),
          _buildStatDivider(),
          _buildStatItem('⚡', 'Instant Results'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00BCD4),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.55)),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 30,
      color: Colors.white.withOpacity(0.1),
    );
  }

  Widget _buildPrimaryCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/input'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1565C0), Color(0xFF0B3D4A)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1565C0).withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.rocket_launch_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Start New Simulation',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Build your own population model',
                    style: TextStyle(fontSize: 12, color: Colors.white60),
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: color, width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A1628),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoStrip() {
    final tags = [
      '🌿 Ecology',
      '🦌 Wildlife',
      '📊 Conservation',
      '🔬 Research',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Use Cases',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                tag,
                style: const TextStyle(fontSize: 12, color: Color(0xFF0A1628)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomBranding() {
    return Center(
      child: Column(
        children: [
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 12),
          Text(
            'Powered by',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 4),
          const Text(
            'Al-Najaf IT Solutions',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0B3D4A),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  void _loadSampleAndNavigate(BuildContext context) {
    final formViewModel = Provider.of<InputFormViewModel>(
      context,
      listen: false,
    );
    formViewModel.loadSampleData();
    Navigator.pushNamed(context, '/input');
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF6A1B9A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.auto_stories_outlined,
                color: Color(0xFF6A1B9A),
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text('Leslie Matrix Model', style: TextStyle(fontSize: 16)),
          ],
        ),
        content: const SingleChildScrollView(
          child: Text(
            'The Leslie matrix is a mathematical model used in ecology and '
            'population biology to predict population growth based on '
            'age-specific birth and survival rates.\n\n'
            'λ (Lambda) = Growth Rate\n'
            '• λ > 1.05: Population is growing\n'
            '• 0.95 ≤ λ ≤ 1.05: Population is stable\n'
            '• λ < 0.95: Population is declining\n\n'
            'The model helps wildlife managers and ecologists understand '
            'population dynamics and make conservation decisions.',
            style: TextStyle(fontSize: 13, height: 1.6),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 10.0;

    final segments = [
      (0.35, const Color(0xFF00BCD4)),
      (0.25, const Color(0xFF1565C0)),
      (0.20, const Color(0xFF2E7D32)),
      (0.12, const Color(0xFF6A1B9A)),
      (0.08, const Color(0xFFE65100)),
    ];

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    double startAngle = -1.5708; // -90 degrees in radians

    for (final segment in segments) {
      paint.color = segment.$2;
      final sweepAngle = segment.$1 * 2 * 3.14159;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle - 0.05,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }

    // Outer glow ring
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withOpacity(0.1);
    canvas.drawCircle(center, radius + strokeWidth / 2 + 4, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
