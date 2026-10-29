class Credit {
  final int? id;
  final String type, toName, plan;
  final double amount;
  final DateTime date;

  const Credit({
    this.id,
    required this.type,
    required this.toName,
    required this.plan,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'to_name': toName,
        'plan': plan,
        'amount': amount,
        'date': date.toIso8601String(),
      };

  factory Credit.fromMap(Map<String, dynamic> m) => Credit(
        id: m['id'] as int,
        type: m['type'] as String,
        toName: m['to_name'] as String,
        plan: m['plan'] as String,
        amount: (m['amount'] as num).toDouble(),
        date: DateTime.parse(m['date'] as String),
      );
}
