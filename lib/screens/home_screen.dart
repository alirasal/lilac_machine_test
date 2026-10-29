import 'package:flutter/material.dart';
import '../database/app_store.dart';
import '../widgets/form_widgets.dart';
import '../database/profile_store.dart';
import '../theme/app_theme.dart';
import '../widgets/tx_tile.dart';
import 'transaction_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onSeeAll;
  const HomeScreen({super.key, required this.onSeeAll});

  String get _greeting {
    final h = DateTime.now().hour;
    return h < 12 ? 'Good morning' : (h < 17 ? 'Good afternoon' : 'Good evening');
  }

  Widget _stat(String label, double v) => Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 9, color: AppColors.grey)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(6)),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(money(v),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
      );

  Widget _flow(IconData i, String t, double v) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(i, size: 14, color: Colors.white70),
            const SizedBox(width: 4),
            Text(t, style: const TextStyle(color: Colors.white70, fontSize: 10)),
          ]),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(money(v),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final s = AppStore.instance;
    return SafeArea(
      child: ResponsiveCenter(child: ListenableBuilder(
        listenable: s,
        builder: (_, __) {
          final recent = s.expenses.take(5).toList();
          return ListView(padding: const EdgeInsets.all(16), children: [
            Text('$_greeting,',
                style: const TextStyle(fontSize: 10, color: AppColors.grey)),
            ListenableBuilder(
              listenable: ProfileStore.instance,
              builder: (_, __) => Text(ProfileStore.instance.name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Total Balance',
                    style: TextStyle(color: Colors.white70, fontSize: 11)),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(money(s.balance),
                      style: const TextStyle(
                          color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 14),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Flexible(child: _flow(Icons.arrow_downward, 'Income', s.income)),
                  const SizedBox(width: 8),
                  Flexible(child: _flow(Icons.arrow_upward, 'Expenses', s.spent)),
                ]),
              ]),
            ),
            const SizedBox(height: 16),
            Row(children: [
              _stat('DAILY AVERAGE', s.dailyAverage),
              const SizedBox(width: 12),
              _stat('WEEKLY', s.weekly),
            ]),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Transactions History',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              GestureDetector(
                  onTap: onSeeAll,
                  child: const Text('See all',
                      style: TextStyle(fontSize: 10, color: AppColors.grey))),
            ]),
            if (s.error != null)
              Text(s.error!, style: const TextStyle(color: AppColors.red, fontSize: 11)),
            if (recent.isEmpty) const EmptyState('No transactions yet'),
            ...recent.map((e) => TxTile(
                  e: e,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => TransactionScreen(expense: e))),
                )),
            const SizedBox(height: 70),
          ]);
        },
      )),
    );
  }
}
