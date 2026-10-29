import 'package:flutter/foundation.dart';
import '../models/credit.dart';
import '../models/expense.dart';
import 'db_helper.dart';

/// Holds app state; screens rebuild automatically via ListenableBuilder.
class AppStore extends ChangeNotifier {
  AppStore._();
  static final AppStore instance = AppStore._();
  final _db = DbHelper.instance;

  List<Expense> expenses = [];
  List<Credit> credits = [];
  String? error;

  double get income =>
      expenses.where((e) => e.isIncome).fold(0.0, (s, e) => s + e.amount);
  double get spent =>
      expenses.where((e) => !e.isIncome).fold(0.0, (s, e) => s + e.amount);
  double get balance => income - spent;

  double get weekly {
    final from = DateTime.now().subtract(const Duration(days: 7));
    return expenses
        .where((e) => !e.isIncome && e.date.isAfter(from))
        .fold(0.0, (s, e) => s + e.amount);
  }

  double get dailyAverage => weekly / 7;

  Future<bool> _run(Future<void> Function() job) async {
    try {
      await job();
      expenses = await _db.getExpenses();
      credits = await _db.getCredits();
      error = null;
    } catch (e) {
      error = 'Database error: $e';
    }
    notifyListeners();
    return error == null;
  }

  Future<bool> load() => _run(() async {});
  Future<bool> addExpense(Expense e) => _run(() => _db.insertExpense(e));
  Future<bool> updateExpense(Expense e) => _run(() => _db.updateExpense(e));
  Future<bool> deleteExpense(int id) => _run(() => _db.deleteExpense(id));
  Future<bool> addCredit(Credit c) => _run(() => _db.insertCredit(c));
  Future<bool> deleteCredit(int id) => _run(() => _db.deleteCredit(id));
  Future<bool> clearAll() => _run(() => _db.clearAll());
}
