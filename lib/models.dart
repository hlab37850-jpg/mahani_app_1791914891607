import 'package:flutter/material.dart';

enum TransactionType { income, expense }

extension TransactionTypeX on TransactionType {
  String get name => toString().split('.').last;
  static TransactionType fromString(String value) =>
      TransactionType.values.firstWhere((e) => e.name == value);
}

class Transaction {
  final int id;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final int categoryId;
  final String? note;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.date,
    required this.categoryId,
    this.note,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) => Transaction(
        id: map['id'] as int,
        amount: (map['amount'] as num).toDouble(),
        type: TransactionTypeX.fromString(map['type'] as String),
        date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
        categoryId: map['categoryId'] as int,
        note: map['note'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'amount': amount,
        'type': type.name,
        'date': date.millisecondsSinceEpoch,
        'categoryId': categoryId,
        'note': note,
      };
}

class Category {
  final int id;
  final String name;
  final Color color;
  final bool isIncome;

  Category({
    required this.id,
    required this.name,
    required this.color,
    required this.isIncome,
  });

  factory Category.fromMap(Map<String, dynamic> map) => Category(
        id: map['id'] as int,
        name: map['name'] as String,
        color: Color(map['color'] as int),
        isIncome: (map['isIncome'] as int) == 1,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'color': color.toARGB32,
        'isIncome': isIncome ? 1 : 0,
      };
}

class Budget {
  final int id;
  final int categoryId;
  final double limit;
  final DateTime periodStart;
  final DateTime periodEnd;

  Budget({
    required this.id,
    required this.categoryId,
    required this.limit,
    required this.periodStart,
    required this.periodEnd,
  });

  factory Budget.fromMap(Map<String, dynamic> map) => Budget(
        id: map['id'] as int,
        categoryId: map['categoryId'] as int,
        limit: (map['limit'] as num).toDouble(),
        periodStart: DateTime.fromMillisecondsSinceEpoch(map['periodStart'] as int),
        periodEnd: DateTime.fromMillisecondsSinceEpoch(map['periodEnd'] as int),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'categoryId': categoryId,
        'limit': limit,
        'periodStart': periodStart.millisecondsSinceEpoch,
        'periodEnd': periodEnd.millisecondsSinceEpoch,
      };
}
