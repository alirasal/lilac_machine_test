import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'credit_screen.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'transaction_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _i = 0;

  Widget _nav(IconData icon, int index) => Expanded(
        child: IconButton(
          onPressed: () => setState(() => _i = index),
          icon: Icon(icon,
              size: 26, color: _i == index ? Colors.white : Colors.white54),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(index: _i, children: [
          HomeScreen(onSeeAll: () => setState(() => _i = 1)),
          const HistoryScreen(),
          const CreditScreen(),
          const ProfileScreen(),
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 3)),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const TransactionScreen())),
          child: const Icon(Icons.add, size: 30),
        ),
        bottomNavigationBar: BottomAppBar(
          color: AppColors.primary,
          surfaceTintColor: Colors.transparent,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Row(children: [
                _nav(Icons.home_outlined, 0),
                _nav(Icons.history, 1),
                const Expanded(child: SizedBox()), // gap for + button
                _nav(Icons.account_balance_wallet_outlined, 2),
                _nav(Icons.person_outline, 3),
              ]),
            ),
          ),
        ),
      );
}
