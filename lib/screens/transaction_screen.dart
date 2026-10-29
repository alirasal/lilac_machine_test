import 'package:flutter/material.dart';
import '../database/app_store.dart';
import '../models/expense.dart';
import '../widgets/form_widgets.dart';

class TransactionScreen extends StatefulWidget {
  final Expense? expense; // null = add, non-null = edit
  const TransactionScreen({super.key, this.expense});
  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  static const _categories = [
    'Food', 'Shopping', 'Transport', 'Bills', 'Salary', 'Entertainment', 'Other'
  ];
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.expense?.name);
  late final _amount = TextEditingController(
      text: widget.expense == null ? '' : widget.expense!.amount.toString());
  late final _desc = TextEditingController(text: widget.expense?.description);
  late String _type = widget.expense?.type ?? 'Expense';
  late String _category = widget.expense?.category ?? 'Other';
  late DateTime _date = widget.expense?.date ?? DateTime.now();

  bool get _isEdit => widget.expense != null;

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    _desc.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final e = Expense(
      id: widget.expense?.id,
      name: _name.text.trim(),
      type: _type,
      category: _category,
      amount: double.parse(_amount.text.trim()),
      date: _date,
      description: _desc.text.trim(),
    );
    final s = AppStore.instance;
    final ok = _isEdit ? await s.updateExpense(e) : await s.addExpense(e);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok
            ? (_isEdit ? 'Transaction updated' : 'Transaction added')
            : s.error ?? 'Something went wrong')));
    if (ok) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: tealAppBar(_isEdit ? 'Edit Transaction' : 'Transaction', back: true),
        body: ResponsiveCenter(child: SafeArea(
          child: Column(children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _form,
                  child: FormCard(
                    child: Column(children: [
                      AppDropdown(
                          label: 'Transaction Type',
                          value: _type,
                          items: const ['Expense', 'Income'],
                          onChanged: (v) => setState(() => _type = v)),
                      AppField(
                        label: 'Name',
                        controller: _name,
                        hint: 'Netflix',
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                      ),
                      AppField(
                        label: 'Amount',
                        controller: _amount,
                        hint: '48.00',
                        prefix: '₹ ',
                        keyboard: const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) {
                          final n = double.tryParse((v ?? '').trim());
                          if (n == null) return 'Enter a valid amount';
                          if (n <= 0) return 'Amount must be greater than 0';
                          return null;
                        },
                      ),
                      AppDropdown(
                          label: 'Category',
                          value: _category,
                          items: _categories,
                          onChanged: (v) => setState(() => _category = v)),
                      DateField(
                          label: 'Date',
                          value: _date,
                          onChanged: (d) => setState(() => _date = d)),
                      AppField(
                          label: 'Description (optional)',
                          controller: _desc,
                          maxLines: 2),
                    ]),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: PrimaryButton('Save', onPressed: _save),
            ),
          ]),
        )),
      );
}
