class Expense {
  final int? id;
  final String name, type, category, description;
  final double amount;
  final DateTime date;

  const Expense({
    this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
    this.description = '',
  });

  bool get isIncome => type == 'Income';

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'type': type,
        'category': category,
        'description': description,
        'amount': amount,
        'date': date.toIso8601String(),
      };

  factory Expense.fromMap(Map<String, dynamic> m) => Expense(
        id: m['id'] as int,
        name: m['name'] as String,
        type: m['type'] as String,
        category: m['category'] as String,
        description: (m['description'] ?? '') as String,
        amount: (m['amount'] as num).toDouble(),
        date: DateTime.parse(m['date'] as String),
      );
}
