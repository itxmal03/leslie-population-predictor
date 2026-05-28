import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: const Interval(0.0, 0.5)),
    );

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 700));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _progressController.forward();
    await Future.delayed(const Duration(milliseconds: 2200));
   if (mounted) Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A1628), Color(0xFF0D2137), Color(0xFF0B3D4A)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background decorative lambda symbol
            Positioned(
              right: -40,
              top: 80,
              child: Text(
                'λ',
                style: TextStyle(
                  fontSize: 280,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withValues(alpha:0.03),
                ),
              ),
            ),

            // Background decorative dots grid
            Positioned.fill(child: CustomPaint(painter: _DotGridPainter())),

            // Main content
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with glow
                    FadeTransition(
                      opacity: _logoFadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha:0.07),
                            border: Border.all(
                              color: const Color(0xFF00BCD4).withValues(alpha:0.4),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF00BCD4,
                                ).withValues(alpha:0.25),
                                blurRadius: 40,
                                spreadRadius: 8,
                              ),
                            ],
                          ),

                          child: // Replace the ClipOval Image.asset block with:
                          Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Inner fill
                                Container(
                                  width: 116,
                                  height: 116,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const RadialGradient(
                                      colors: [
                                        Color(0xFF0D2F45),
                                        Color(0xFF0A1628),
                                      ],
                                      radius: 0.8,
                                    ),
                                  ),
                                ),
                                // λ symbol
                                const Text(
                                  'λ',
                                  style: TextStyle(
                                    fontSize: 58,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.0,
                                  ),
                                ),
                                // Cyan arc accent (top-right quadrant)
                                SizedBox(
                                  width: 116,
                                  height: 116,
                                  child: CustomPaint(
                                    painter: _LogoArcPainter(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // App name + tagline
                    FadeTransition(
                      opacity: _textFadeAnimation,
                      child: SlideTransition(
                        position: _textSlideAnimation,
                        child: Column(
                          children: [
                            const Text(
                              'Leslie Predictor',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Age-Structured Population Modeling',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha:0.6),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Lambda badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(
                                    0xFF00BCD4,
                                  ).withValues(alpha:0.4),
                                ),
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(
                                  0xFF00BCD4,
                                ).withValues(alpha:0.08),
                              ),
                              child: Text(
                                'λ · Leslie Matrix Model',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: const Color(
                                    0xFF00BCD4,
                                  ).withValues(alpha:0.9),
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Progress bar
                    FadeTransition(
                      opacity: _textFadeAnimation,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 160,
                            child: AnimatedBuilder(
                              animation: _progressController,
                              builder: (context, _) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: _progressController.value,
                                    backgroundColor: Colors.white.withValues(alpha:
                                      0.08,
                                    ),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Color(0xFF00BCD4),
                                        ),
                                    minHeight: 3,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Initializing model...',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha:0.35),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom branding
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _textFadeAnimation,
                child: Column(
                  children: [
                    Text(
                      'Powered by',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha:0.45),
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Al-Najaf IT Solutions',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF00BCD4),
                        letterSpacing: 0.8,
                      ),
                      textAlign: TextAlign.center,
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

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha:0.04)
      ..strokeWidth = 1;

    const spacing = 30.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LogoArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;

    // Main cyan arc (270 degrees, leaving a gap at bottom-left)
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFF00BCD4);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -2.4, // start angle
      5.5, // sweep (almost full circle)
      false,
      arcPaint,
    );

    // Bright dot at arc end
    final dotPaint = Paint()
      ..color = const Color(0xFF00BCD4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx - 10, center.dy + radius - 1),
      3.5,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
