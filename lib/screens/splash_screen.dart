import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()));
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        backgroundColor: AppColors.light,
        body: Center(
          child: Text('Expenzia',
              style: TextStyle(
                  color: Colors.white, fontSize: 34, fontWeight: FontWeight.w700)),
        ),
      );
}
