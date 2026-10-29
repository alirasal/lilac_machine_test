import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../theme/app_theme.dart';

class TxTile extends StatelessWidget {
  final Expense e;
  final VoidCallback? onTap;
  const TxTile({super.key, required this.e, this.onTap});
  @override
  Widget build(BuildContext context) {
    final c = e.isIncome ? AppColors.green : AppColors.red;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(e.name,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text('${dateLabel(e.date)} • ${e.category}',
                  style: const TextStyle(fontSize: 10, color: AppColors.grey)),
            ]),
            Text('${e.isIncome ? '+' : '-'} ${money(e.amount)}',
                style: TextStyle(fontSize: 13, color: c, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final String text;
  const EmptyState(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.border),
            const SizedBox(height: 8),
            Text(text, style: const TextStyle(color: AppColors.grey, fontSize: 13)),
          ]),
        ),
      );
}
