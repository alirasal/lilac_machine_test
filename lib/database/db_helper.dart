import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/credit.dart';
import '../models/expense.dart';

class DbHelper {
  DbHelper._();
  static final DbHelper instance = DbHelper._();
  Database? _db;

  Future<Database> get db async => _db ??= await _open();

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), 'expenzia.db');
    return openDatabase(path, version: 1, onCreate: (d, _) async {
      await d.execute('''CREATE TABLE expenses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL, type TEXT NOT NULL, category TEXT NOT NULL,
        description TEXT, amount REAL NOT NULL, date TEXT NOT NULL)''');
      await d.execute('''CREATE TABLE credits(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL, to_name TEXT NOT NULL, plan TEXT NOT NULL,
        amount REAL NOT NULL, date TEXT NOT NULL)''');
    });
  }

  // ---- Expenses CRUD ----
  Future<int> insertExpense(Expense e) async =>
      (await db).insert('expenses', e.toMap()..remove('id'));

  Future<List<Expense>> getExpenses() async {
    final rows = await (await db).query('expenses', orderBy: 'date DESC, id DESC');
    return rows.map(Expense.fromMap).toList();
  }

  Future<int> updateExpense(Expense e) async => (await db)
      .update('expenses', e.toMap(), where: 'id = ?', whereArgs: [e.id]);

  Future<int> deleteExpense(int id) async =>
      (await db).delete('expenses', where: 'id = ?', whereArgs: [id]);

  // ---- Credits ----
  Future<int> insertCredit(Credit c) async =>
      (await db).insert('credits', c.toMap()..remove('id'));

  Future<List<Credit>> getCredits() async {
    final rows = await (await db).query('credits', orderBy: 'date ASC');
    return rows.map(Credit.fromMap).toList();
  }

  Future<int> deleteCredit(int id) async =>
      (await db).delete('credits', where: 'id = ?', whereArgs: [id]);

  Future<void> clearAll() async {
    final d = await db;
    await d.delete('expenses');
    await d.delete('credits');
  }
}
