import 'package:flutter/material.dart';
import 'package:leslie_predictor/widgets/animated_donut.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with TickerProviderStateMixin {
  late Animation<double> _heroFade;
  late Animation<Offset> _heroSlide;
  late AnimationController _heroController;

  @override
  void initState() {
    super.initState();

    _heroController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _heroFade = CurvedAnimation(parent: _heroController, curve: Curves.easeIn);

    _heroSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _heroController, curve: Curves.easeOut));

    _heroController.forward();
  }

  @override
  void dispose() {
    _heroController.dispose();
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
          'About Leslie Model',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _heroFade,
        child: SlideTransition(
          position: _heroSlide,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildHeroCard(),
                const SizedBox(height: 16),
                _buildWhatIsCard(),
                const SizedBox(height: 16),
                _buildHowItWorksCard(),
                const SizedBox(height: 16),
                _buildMatrixCard(),
                const SizedBox(height: 16),
                _buildLambdaCard(),
                const SizedBox(height: 16),
                _buildStepsCard(),
                const SizedBox(height: 16),
                _buildUsedForCard(),
                const SizedBox(height: 16),
                _buildFormulaCard(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Hero Card
  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A1628), Color(0xFF0B3D4A)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A1628).withValues(alpha: 0.3),
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
                color: Colors.white.withValues(alpha: 0.04),
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
                        color: const Color(0xFF00BCD4).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF00BCD4).withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Text(
                        'Population Biology',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF00BCD4),
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Leslie\nMatrix\nModel',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Developed by P.H. Leslie\nin 1945 for age-structured\npopulation analysis',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.55),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedDonut(centerText: 'λ', centerSubText: '1945', size: 110),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWhatIsCard() {
    return _buildSectionCard(
      icon: Icons.info_outline_rounded,
      iconColor: const Color(0xFF1565C0),
      title: 'What is the Leslie Matrix?',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBodyText(
            'The Leslie Matrix is a square matrix used in ecology to model '
            'how a population changes over time when divided into age groups.',
          ),
          const SizedBox(height: 10),
          _buildBodyText(
            'Each age group has its own birth rate and survival rate. '
            'Multiplying the matrix by a population vector gives the '
            'population at the next time step.',
          ),
          const SizedBox(height: 14),
          _buildHighlightBox(
            icon: Icons.lightbulb_outline,
            color: const Color(0xFF1565C0),
            text:
                'Think of it as a time machine for populations — input today\'s numbers and get tomorrow\'s forecast.',
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksCard() {
    return _buildSectionCard(
      icon: Icons.settings_outlined,
      iconColor: const Color(0xFF0B3D4A),
      title: 'How Does It Work?',
      child: Column(
        children: [
          _buildStepRow(
            step: '1',
            color: const Color(0xFF1565C0),
            title: 'Divide population into age groups',
            subtitle: 'e.g. Age 1, Age 2, Age 3 ...',
          ),
          _buildStepRow(
            step: '2',
            color: const Color(0xFF2E7D32),
            title: 'Assign birth rates per group',
            subtitle: 'How many offspring each age group produces',
          ),
          _buildStepRow(
            step: '3',
            color: const Color(0xFF6A1B9A),
            title: 'Assign survival rates per group',
            subtitle: 'Probability of surviving to the next age group',
          ),
          _buildStepRow(
            step: '4',
            color: const Color(0xFF00BCD4),
            title: 'Build the Leslie Matrix',
            subtitle: 'Birth rates on row 1, survival rates on subdiagonal',
          ),
          _buildStepRow(
            step: '5',
            color: const Color(0xFFE65100),
            title: 'Multiply matrix × population vector',
            subtitle: 'Repeat for each year of the projection',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMatrixCard() {
    return _buildSectionCard(
      icon: Icons.grid_on_rounded,
      iconColor: const Color(0xFF2E7D32),
      title: 'Matrix Structure',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBodyText(
            'For 3 age groups, the Leslie Matrix looks like this:',
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0A1628),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildMatrixRow(
                  ['f₁', 'f₂', 'f₃'],
                  colors: [
                    const Color(0xFF00BCD4),
                    const Color(0xFF00BCD4),
                    const Color(0xFF00BCD4),
                  ],
                  label: '← Birth rates',
                  labelColor: const Color(0xFF00BCD4),
                ),
                const SizedBox(height: 6),
                _buildMatrixRow(
                  ['s₁', '0', '0'],
                  colors: [
                    const Color(0xFF2E7D32),
                    Colors.white.withValues(alpha: 0.3),
                    Colors.white.withValues(alpha: 0.3),
                  ],
                  label: '← Survival rates',
                  labelColor: const Color(0xFF2E7D32),
                ),
                const SizedBox(height: 6),
                _buildMatrixRow(
                  ['0', 's₂', '0'],
                  colors: [
                    Colors.white.withValues(alpha: 0.3),
                    const Color(0xFF2E7D32),
                    Colors.white.withValues(alpha: 0.3),
                  ],
                  label: '',
                  labelColor: Colors.transparent,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildLegendDot(const Color(0xFF00BCD4)),
              const SizedBox(width: 6),
              _buildBodyText('f = fecundity (birth rate)'),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              _buildLegendDot(const Color(0xFF2E7D32)),
              const SizedBox(width: 6),
              _buildBodyText('s = survival rate (0 to 1)'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLambdaCard() {
    return _buildSectionCard(
      icon: Icons.show_chart_rounded,
      iconColor: const Color(0xFF6A1B9A),
      title: 'Understanding λ (Lambda)',
      child: Column(
        children: [
          _buildBodyText(
            'Lambda is the dominant eigenvalue of the Leslie Matrix. '
            'It tells you the long-term growth rate of the population.',
          ),
          const SizedBox(height: 16),
          _buildLambdaRow(
            symbol: 'λ > 1.05',
            label: 'Growing',
            description: 'Population increases each year',
            color: const Color(0xFF2E7D32),
            icon: Icons.trending_up,
          ),
          const SizedBox(height: 8),
          _buildLambdaRow(
            symbol: 'λ ≈ 1.0',
            label: 'Stable',
            description: 'Population stays roughly constant',
            color: const Color(0xFFF57F17),
            icon: Icons.trending_flat,
          ),
          const SizedBox(height: 8),
          _buildLambdaRow(
            symbol: 'λ < 0.95',
            label: 'Declining',
            description: 'Population shrinks over time',
            color: const Color(0xFFC62828),
            icon: Icons.trending_down,
          ),
          const SizedBox(height: 14),
          _buildHighlightBox(
            icon: Icons.calculate_outlined,
            color: const Color(0xFF6A1B9A),
            text:
                'λ = 2.0 means the population doubles every generation. λ = 0.5 means it halves.',
          ),
        ],
      ),
    );
  }

  Widget _buildStepsCard() {
    return _buildSectionCard(
      icon: Icons.rocket_launch_outlined,
      iconColor: const Color(0xFF00BCD4),
      title: 'How to Use This App',
      child: Column(
        children: [
          _buildAppStepRow(
            icon: Icons.group_outlined,
            color: const Color(0xFF1565C0),
            title: 'Set age groups',
            subtitle: 'Choose 2 to 10 age groups for your species',
          ),
          _buildAppStepRow(
            icon: Icons.child_friendly_outlined,
            color: const Color(0xFF2E7D32),
            title: 'Enter birth rates',
            subtitle: 'Average offspring per female per year per group',
          ),
          _buildAppStepRow(
            icon: Icons.favorite_outline,
            color: const Color(0xFF6A1B9A),
            title: 'Set survival rates',
            subtitle: 'Probability 0–1 of moving to the next age group',
          ),
          _buildAppStepRow(
            icon: Icons.people_outline,
            color: const Color(0xFF0B3D4A),
            title: 'Enter initial population',
            subtitle: 'How many individuals are in each age group now',
          ),
          _buildAppStepRow(
            icon: Icons.calendar_today_outlined,
            color: const Color(0xFFE65100),
            title: 'Choose projection years',
            subtitle: 'How many years into the future to simulate',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildUsedForCard() {
    final items = [
      _InfoChip(icon: '🌿', label: 'Ecology', color: const Color(0xFF2E7D32)),
      _InfoChip(icon: '🦌', label: 'Wildlife', color: const Color(0xFF0B3D4A)),
      _InfoChip(
        icon: '📊',
        label: 'Conservation',
        color: const Color(0xFF1565C0),
      ),
      _InfoChip(icon: '🔬', label: 'Research', color: const Color(0xFF6A1B9A)),
      _InfoChip(icon: '🐟', label: 'Fisheries', color: const Color(0xFF00838F)),
      _InfoChip(
        icon: '🌾',
        label: 'Agriculture',
        color: const Color(0xFF558B2F),
      ),
    ];

    return _buildSectionCard(
      icon: Icons.public_outlined,
      iconColor: const Color(0xFF00838F),
      title: 'Real World Applications',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBodyText(
            'The Leslie Matrix is used across many fields wherever '
            'age-structured population data is available.',
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((chip) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: chip.color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: chip.color.withValues(alpha: 0.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(chip.icon, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(
                      chip.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: chip.color,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaCard() {
    return _buildSectionCard(
      icon: Icons.functions_rounded,
      iconColor: const Color(0xFFE65100),
      title: 'The Core Formula',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBodyText(
            'The entire model is based on one elegant matrix equation:',
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF0A1628),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'n(t+1) = L · n(t)',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00BCD4),
                    letterSpacing: 1.2,
                    fontFamily: 'monospace',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
                const SizedBox(height: 12),
                _buildFormulaLegendRow(
                  'n(t)',
                  'Population vector at time t',
                  const Color(0xFF00BCD4),
                ),
                const SizedBox(height: 6),
                _buildFormulaLegendRow(
                  'L',
                  'The Leslie Matrix',
                  const Color(0xFF2E7D32),
                ),
                const SizedBox(height: 6),
                _buildFormulaLegendRow(
                  'n(t+1)',
                  'Population vector at next time step',
                  const Color(0xFF6A1B9A),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _buildHighlightBox(
            icon: Icons.auto_awesome_outlined,
            color: const Color(0xFFE65100),
            text:
                'Applying this repeatedly for N years gives you the full population projection over time.',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
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
            color: Colors.black.withValues(alpha: 0.05),
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
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A1628),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildBodyText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.6),
    );
  }

  Widget _buildHighlightBox({
    required IconData icon,
    required Color color,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: color,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow({
    required String step,
    required Color color,
    required String title,
    required String subtitle,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Center(
                child: Text(
                  step,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 32,
                color: color.withValues(alpha: 0.2),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0A1628),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppStepRow({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 28,
                color: color.withValues(alpha: 0.15),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0A1628),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLambdaRow({
    required String symbol,
    required String label,
    required String description,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              symbol,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatrixRow(
    List<String> values, {
    required List<Color> colors,
    required String label,
    required Color labelColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          child: Row(
            children: List.generate(values.length, (i) {
              return Container(
                width: 36,
                height: 32,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: colors[i].withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    values[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: colors[i],
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: labelColor,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildFormulaLegendRow(String symbol, String meaning, Color color) {
    return Row(
      children: [
        Container(
          width: 52,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            symbol,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'monospace',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            meaning,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _InfoChip {
  final String icon;
  final String label;
  final Color color;
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });
}
