import 'package:flutter/material.dart';
import 'package:leslie_predictor/screens/about_screen.dart';
import 'package:provider/provider.dart';
import 'viewmodels/input_form_viewmodel.dart';
import 'viewmodels/leslie_calculator_viewmodel.dart';
import 'viewmodels/result_viewmodel.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/input_form_screen.dart';
import 'screens/result_screen.dart';

void main() {
  runApp(const LeslieApp());
}

class LeslieApp extends StatelessWidget {
  const LeslieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InputFormViewModel()),
        ChangeNotifierProvider(create: (_) => LeslieCalculatorViewModel()),
        ChangeNotifierProvider(create: (_) => ResultViewModel()),
      ],
      child: MaterialApp(
        title: 'Leslie Predictor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1976D2)),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF1976D2),
            elevation: 0,
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/input': (context) => const InputFormScreen(),
          '/result': (context) => const ResultScreen(),
          '/about': (context) => const AboutScreen(),
        },
      ),
    );
  }
}
