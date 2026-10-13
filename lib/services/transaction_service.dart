import 'dart:async';

/// Simple transaction model used by the service.
class Transaction {
  final int id;
  final double amount; // Positive for income, negative for expense.
  final String category;
  final DateTime date;
  Transaction({required this.id, required this.amount, required this.category, required this.date});
}

/// Abstract repository that must be implemented by the data layer.
abstract class TransactionRepository {
  Future<void> insert(Transaction transaction);
  Future<List<Transaction>> fetchAll();
  Future<void> delete(int id);
  Future<void> update(Transaction transaction);
}

/// Business‑logic service that validates and aggregates transactions.
class TransactionService {
  final TransactionRepository _repo;
  TransactionService(this._repo);

  /// Adds a new transaction after basic validation.
  Future<void> addTransaction({
    required double amount,
    required String category,
    DateTime? date,
  }) async {
    if (category.isEmpty) {
      throw ArgumentError('Category must not be empty');
    }
    if (amount == 0) {
      throw ArgumentError('Amount cannot be zero');
    }
    final tx = Transaction(
      id: DateTime.now().millisecondsSinceEpoch,
      amount: amount,
      category: category,
      date: date ?? DateTime.now(),
    );
    await _repo.insert(tx);
  }

  /// Returns the total balance (income minus expenses).
  Future<double> getBalance() async {
    final all = await _repo.fetchAll();
    return all.fold(0.0, (sum, tx) => sum + tx.amount);
  }

  /// Returns total income per category.
  Future<Map<String, double>> incomeByCategory() async {
    final all = await _repo.fetchAll();
    final map = <String, double>{};
    for (final tx in all) {
      if (tx.amount > 0) {
        map.update(tx.category, (v) => v + tx.amount, ifAbsent: () => tx.amount);
      }
    }
    return map;
  }

  /// Returns total expense per category (absolute values).
  Future<Map<String, double>> expenseByCategory() async {
    final all = await _repo.fetchAll();
    final map = <String, double>{};
    for (final tx in all) {
      if (tx.amount < 0) {
        final val = tx.amount.abs();
        map.update(tx.category, (v) => v + val, ifAbsent: () => val);
      }
    }
    return map;
  }

  /// Deletes a transaction.
  Future<void> removeTransaction(int id) async => await _repo.delete(id);

  /// Updates an existing transaction after validation.
  Future<void> updateTransaction(Transaction transaction) async {
    if (transaction.category.isEmpty) {
      throw ArgumentError('Category must not be empty');
    }
    if (transaction.amount == 0) {
      throw ArgumentError('Amount cannot be zero');
    }
    await _repo.update(transaction);
  }
}
