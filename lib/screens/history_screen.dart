import 'package:flutter/material.dart';
import '../database/app_store.dart';
import '../theme/app_theme.dart';
import '../widgets/form_widgets.dart';
import '../widgets/tx_tile.dart';
import 'transaction_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStore.instance;
    return Scaffold(
      appBar: tealAppBar('Transaction History'),
      body: ResponsiveCenter(child: ListenableBuilder(
        listenable: s,
        builder: (_, __) {
          if (s.expenses.isEmpty) {
            return const EmptyState('No expenses added yet');
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
            itemCount: s.expenses.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.border),
            itemBuilder: (_, i) {
              final e = s.expenses[i];
              return Dismissible(
                key: ValueKey(e.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: AppColors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                // Delete with confirmation; the list rebuilds from the store.
                confirmDismiss: (_) async {
                  if (await confirmDialog(context, 'Delete transaction',
                      'Delete "${e.name}"? This cannot be undone.')) {
                    await s.deleteExpense(e.id!);
                  }
                  return false;
                },
                child: TxTile(
                  e: e,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => TransactionScreen(expense: e))),
                ),
              );
            },
          );
        },
      )),
    );
  }
}
