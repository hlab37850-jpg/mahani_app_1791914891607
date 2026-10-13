import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

// ---------- Models ----------
class TransactionModel {
  final int? id;
  final double amount;
  final int categoryId;
  final DateTime date;
  final String? note;
  final bool isIncome;

  TransactionModel({
    this.id,
    required this.amount,
    required this.categoryId,
    required this.date,
    this.note,
    required this.isIncome,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'amount': amount,
        'category_id': categoryId,
        'date': date.millisecondsSinceEpoch,
        'note': note,
        'is_income': isIncome ? 1 : 0,
      };

  factory TransactionModel.fromMap(Map<String, Object?> map) => TransactionModel(
        id: map['id'] as int?,
        amount: (map['amount'] as num).toDouble(),
        categoryId: map['category_id'] as int,
        date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
        note: map['note'] as String?,
        isIncome: (map['is_income'] as int) == 1,
      );
}

class CategoryModel {
  final int? id;
  final String name;
  final double? budgetLimit;

  CategoryModel({this.id, required this.name, this.budgetLimit});

  Map<String, Object?> toMap() => {
        'id': id,
        'name': name,
        'budget_limit': budgetLimit,
      };

  factory CategoryModel.fromMap(Map<String, Object?> map) => CategoryModel(
        id: map['id'] as int?,
        name: map['name'] as String,
        budgetLimit: (map['budget_limit'] as num?)?.toDouble(),
      );
}

// ---------- SQLite Helper ----------
class DatabaseHelper {
  static const _dbName = 'masroufati.db';
  static const _dbVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        budget_limit REAL
      );
    ''');
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        category_id INTEGER NOT NULL,
        date INTEGER NOT NULL,
        note TEXT,
        is_income INTEGER NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
      );
    ''');
  }
}

// ---------- Repositories ----------
class TransactionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> insert(TransactionModel transaction) async {
    final db = await _dbHelper.database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<List<TransactionModel>> getAll() async {
    final db = await _dbHelper.database;
    final maps = await db.query('transactions', orderBy: 'date DESC');
    return maps.map((m) => TransactionModel.fromMap(m)).toList();
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}

class CategoryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> insert(CategoryModel category) async {
    final db = await _dbHelper.database;
    return await db.insert('categories', category.toMap());
  }

  Future<List<CategoryModel>> getAll() async {
    final db = await _dbHelper.database;
    final maps = await db.query('categories');
    return maps.map((m) => CategoryModel.fromMap(m)).toList();
  }

  Future<int> delete(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }
}
