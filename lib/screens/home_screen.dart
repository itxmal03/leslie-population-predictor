import 'package:flutter/material.dart';
import 'package:leslie_predictor/viewmodels/input_form_viewmodel.dart';
import 'package:leslie_predictor/widgets/animated_donut.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.08),
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
                  _buildUseCasesSection(),
                  const SizedBox(height: 20),
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
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0D2137), Color(0xFF0B3D4A)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -20,
            child: Text(
              'λ',
              style: TextStyle(
                fontSize: 160,
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
                        color: Colors.white.withValues(alpha: 0.55),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: AnimatedDonut(
                  centerText: 'λ',
                  centerSubText: 'growth',
                  size: 110,
                ),
              ),
            ],
          ),
        ],
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
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 30,
      color: Colors.white.withValues(alpha: 0.1),
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
              color: const Color(0xFF0B3D4A).withValues(alpha: 0.35),
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
                color: Colors.white.withValues(alpha: 0.12),
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
                color: Colors.white.withValues(alpha: 0.12),
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
              color: Colors.black.withValues(alpha: 0.06),
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
                color: color.withValues(alpha: 0.1),
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

  Widget _buildUseCasesSection() {
    final useCases = [
      _UseCaseItem(
        emoji: '🌿',
        title: 'Ecology',
        description:
            'Model ecosystems and understand how species populations shift '
            'across seasons, habitats, and environmental pressures.',
        color: const Color(0xFF2E7D32),
      ),
      _UseCaseItem(
        emoji: '🦌',
        title: 'Wildlife Management',
        description:
            'Track age-structured wildlife populations to guide hunting '
            'quotas, breeding programs, and reserve planning.',
        color: const Color(0xFF0B3D4A),
      ),
      _UseCaseItem(
        emoji: '📊',
        title: 'Conservation',
        description:
            'Predict extinction risk and recovery trajectories for '
            'endangered species using real demographic data.',
        color: const Color(0xFF1565C0),
      ),
      _UseCaseItem(
        emoji: '🔬',
        title: 'Research',
        description:
            'Use Leslie matrices as a standard tool in population biology '
            'papers to project multi-generational dynamics.',
        color: const Color(0xFF6A1B9A),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Use Cases',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0A1628),
          ),
        ),
        const SizedBox(height: 10),
        ...useCases.map((item) => _UseCaseTile(item: item)),
      ],
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
    Navigator.pushNamed(context, '/about');
  }
}

//Use Case Data Model

class _UseCaseItem {
  final String emoji;
  final String title;
  final String description;
  final Color color;

  const _UseCaseItem({
    required this.emoji,
    required this.title,
    required this.description,
    required this.color,
  });
}

//  Foldable Use Case Tile

class _UseCaseTile extends StatefulWidget {
  final _UseCaseItem item;
  const _UseCaseTile({required this.item});

  @override
  State<_UseCaseTile> createState() => _UseCaseTileState();
}

class _UseCaseTileState extends State<_UseCaseTile>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _expanded
                ? widget.item.color.withValues(alpha: 0.3)
                : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: widget.item.color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Center(
                      child: Text(
                        widget.item.emoji,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.item.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _expanded
                            ? widget.item.color
                            : const Color(0xFF0A1628),
                      ),
                    ),
                  ),
                  RotationTransition(
                    turns: _rotateAnimation,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: _expanded
                          ? widget.item.color
                          : Colors.grey.shade400,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            SizeTransition(
              sizeFactor: _expandAnimation,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      height: 1,
                      color: widget.item.color.withValues(alpha: 0.15),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.item.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.6,
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
}

