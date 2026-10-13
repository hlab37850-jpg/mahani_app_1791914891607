import 'dart:async';

import 'repositories/transaction_repository.dart';
import 'repositories/category_repository.dart';
import 'repositories/budget_repository.dart';
import 'models/transaction.dart';
import 'models/category.dart';
import 'models/budget.dart';

class TransactionService {
  final TransactionRepository _repo;
  TransactionService(this._repo);

  Future<void> addTransaction(Transaction tx) => _repo.insert(tx);

  Future<List<Transaction>> getAll() => _repo.getAll();

  Future<double> getTotalIncome() => _repo.getTotalByType(isIncome: true);

  Future<double> getTotalExpense() => _repo.getTotalByType(isIncome: false);

  Future<double> getBalance() async {
    final income = await getTotalIncome();
    final expense = await getTotalExpense();
    return income - expense;
  }
}

class CategoryService {
  final CategoryRepository _repo;
  CategoryService(this._repo);

  Future<void> addCategory(Category cat) => _repo.insert(cat);

  Future<List<Category>> getAll() => _repo.getAll();
}

class BudgetService {
  final BudgetRepository _repo;
  BudgetService(this._repo);

  Future<void> setBudget(Budget budget) => _repo.upsert(budget);

  Future<Budget?> getBudgetForCategory(int categoryId) => _repo.getByCategoryId(categoryId);

  Future<double> getRemaining(int categoryId) async {
    final budget = await getBudgetForCategory(categoryId);
    if (budget == null) return 0.0;
    final spent = await _repo.getSpentAmount(categoryId);
    return budget.limit - spent;
  }
}
