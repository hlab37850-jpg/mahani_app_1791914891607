import 'package:flutter/foundation.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../models/budget.dart';
import '../repositories/transaction_repository.dart';
import '../repositories/category_repository.dart';
import '../repositories/budget_repository.dart';

class FinanceService {
  final TransactionRepository _transactionRepo;
  final CategoryRepository _categoryRepo;
  final BudgetRepository _budgetRepo;

  FinanceService({
    required TransactionRepository transactionRepository,
    required CategoryRepository categoryRepository,
    required BudgetRepository budgetRepository,
  })  : _transactionRepo = transactionRepository,
        _categoryRepo = categoryRepository,
        _budgetRepo = budgetRepository;

  /// Adds a new financial transaction after validating the category and budget.
  Future<void> addTransaction({
    required double amount,
    required int categoryId,
    required DateTime date,
    String? note,
  }) async {
    if (amount == 0) {
      throw ArgumentError('Amount cannot be zero');
    }
    final Category? category = await _categoryRepo.getById(categoryId);
    if (category == null) {
      throw ArgumentError('Category with id $categoryId does not exist');
    }
    // If expense (negative amount), ensure it does not exceed the budget for the category.
    if (amount < 0) {
      final Budget? budget = await _budgetRepo.getByCategoryId(categoryId);
      if (budget != null) {
        final double spentThisMonth = await _transactionRepo.totalSpentForMonth(
          categoryId: categoryId,
          month: date.month,
          year: date.year,
        );
        final double remaining = budget.limit + spentThisMonth; // budget.limit is negative for expense cap
        if (amount.abs() > remaining.abs()) {
          throw StateError('Expense exceeds remaining budget for this category');
        }
      }
    }
    final transaction = Transaction(
      id: null,
      amount: amount,
      categoryId: categoryId,
      date: date,
      note: note,
    );
    await _transactionRepo.insert(transaction);
  }

  /// Returns the overall balance (income minus expenses).
  Future<double> getBalance() async {
    final List<Transaction> all = await _transactionRepo.getAll();
    double sum = 0.0;
    for (final t in all) {
      sum += t.amount;
    }
    return sum;
  }

  /// Retrieves total spent for a given category in a specific month.
  Future<double> getSpentForCategory({
    required int categoryId,
    required int month,
    required int year,
  }) async {
    return await _transactionRepo.totalSpentForMonth(
      categoryId: categoryId,
      month: month,
      year: year,
    );
  }
}
