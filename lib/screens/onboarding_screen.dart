import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/form_widgets.dart';
import 'main_shell.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFD9F1EC), Colors.white]),
          ),
          child: SafeArea(
            child: ResponsiveCenter(maxWidth: 480, child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(children: [
                const Spacer(),
                // TODO: replace with Figma illustration: Image.asset('assets/onboarding.png')
                const Icon(Icons.account_balance_wallet_rounded,
                    size: 160, color: AppColors.primary),
                const Spacer(),
                const Text('Spend Smarter\nSave More',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 26,
                        height: 1.15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary)),
                const SizedBox(height: 24),
                PrimaryButton('Get Started',
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const MainShell()))),
              ]),
            )),
          ),
        ),
      );
}
