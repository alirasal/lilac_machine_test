import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/app_store.dart';
import '../models/credit.dart';
import '../theme/app_theme.dart';
import '../widgets/form_widgets.dart';
import '../widgets/tx_tile.dart';

class CreditScreen extends StatefulWidget {
  const CreditScreen({super.key});
  @override
  State<CreditScreen> createState() => _CreditScreenState();
}

class _CreditScreenState extends State<CreditScreen> {
  final _form = GlobalKey<FormState>();
  final _to = TextEditingController();
  final _amount = TextEditingController();
  String _type = 'Subscriptions';
  String _plan = 'Monthly';
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _to.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final s = AppStore.instance;
    final ok = await s.addCredit(Credit(
      type: _type,
      toName: _to.text.trim(),
      plan: _plan,
      amount: double.parse(_amount.text.trim()),
      date: _date,
    ));
    if (!mounted) return;
    if (ok) {
      _to.clear();
      _amount.clear();
    }
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ok ? 'Saved' : s.error ?? 'Something went wrong')));
  }

  Widget _due(DateTime d) {
    final today = dateLabel(d) == 'Today';
    return Text(today ? 'Due Today' : 'Due On ${DateFormat('dd/MM/yy').format(d)}',
        style: TextStyle(fontSize: 10, color: today ? AppColors.red : AppColors.grey));
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStore.instance;
    return Scaffold(
      appBar: tealAppBar('Credit'),
      body: ResponsiveCenter(child: ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 90), children: [
        Form(
          key: _form,
          child: Column(children: [
            AppDropdown(
                label: 'Credit Type',
                value: _type,
                items: const ['Subscriptions', 'Loan', 'Bill', 'Other'],
                onChanged: (v) => setState(() => _type = v)),
            AppField(
              label: 'To',
              controller: _to,
              hint: 'Netflix',
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            AppField(
              label: 'Amount',
              controller: _amount,
              prefix: '₹ ',
              keyboard: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                final n = double.tryParse((v ?? '').trim());
                return (n == null || n <= 0) ? 'Enter a valid amount' : null;
              },
            ),
            DateField(
                label: 'Date', value: _date, onChanged: (d) => setState(() => _date = d)),
            AppDropdown(
                label: 'Plan Type',
                value: _plan,
                items: const ['Monthly', 'One-Time', 'Yearly'],
                onChanged: (v) => setState(() => _plan = v)),
            const SizedBox(height: 20),
            PrimaryButton('Save', onPressed: _save),
          ]),
        ),
        const SizedBox(height: 24),
        const Text('Your Saved Lists',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ListenableBuilder(
          listenable: s,
          builder: (_, __) => s.credits.isEmpty
              ? const EmptyState('Nothing saved yet')
              : Column(
                  children: s.credits
                      .map((c) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(c.toName,
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600)),
                            subtitle: _due(c.date),
                            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(c.plan,
                                        style: const TextStyle(
                                            fontSize: 10, color: AppColors.grey)),
                                    Text(money(c.amount),
                                        style: const TextStyle(
                                            fontSize: 13, fontWeight: FontWeight.w600)),
                                  ]),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    size: 18, color: AppColors.red),
                                onPressed: () async {
                                  if (await confirmDialog(context, 'Delete',
                                      'Remove "${c.toName}"?')) {
                                    await s.deleteCredit(c.id!);
                                  }
                                },
                              ),
                            ]),
                          ))
                      .toList(),
                ),
        ),
      ])),
    );
  }
}
