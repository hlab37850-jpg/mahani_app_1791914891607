import 'package:sqflite/sqflite.dart';
import '../models/transaction.dart';
import '../data/database_provider.dart';

class TransactionRepository {
  Future<Database> get _db async => await DatabaseProvider.instance.database;

  Future<List<Transaction>> getAll() async {
    final db = await _db;
    final maps = await db.query('transactions');
    return maps.map((e) => Transaction.fromMap(e)).toList();
  }

  Future<Transaction?> getById(int id) async {
    final db = await _db;
    final maps = await db.query('transactions', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Transaction.fromMap(maps.first);
  }

  Future<int> insert(Transaction transaction) async {
    final db = await _db;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<int> update(Transaction transaction) async {
    final db = await _db;
    return await db.update('transactions', transaction.toMap(), where: 'id = ?', whereArgs: [transaction.id]);
  }

  Future<int> delete(int id) async {
    final db = await _db;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}
