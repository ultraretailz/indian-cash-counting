import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/customer.dart';
import '../models/transaction.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  
  factory DatabaseService() {
    return _instance;
  }
  
  DatabaseService._internal();
  
  Database? _database;
  
  Future<Database> get database async {
    _database ??= await _initializeDatabase();
    return _database!;
  }
  
  Future<Database> _initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'cash_counting.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }
  
  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE customers (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        address TEXT,
        createdAt TEXT NOT NULL
      )
    ''');
    
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        customerId TEXT NOT NULL,
        cashAmount REAL NOT NULL,
        onlineAmount REAL NOT NULL,
        otherAmount REAL NOT NULL,
        description TEXT NOT NULL,
        itemsSold TEXT NOT NULL,
        transactionDate TEXT NOT NULL,
        FOREIGN KEY (customerId) REFERENCES customers (id)
      )
    ''');
  }
  
  // Customer operations
  Future<void> addCustomer(Customer customer) async {
    final db = await database;
    await db.insert('customers', customer.toMap());
  }
  
  Future<List<Customer>> getAllCustomers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('customers');
    return List.generate(maps.length, (i) => Customer.fromMap(maps[i]));
  }
  
  Future<Customer?> getCustomer(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('customers', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Customer.fromMap(maps.first);
    }
    return null;
  }
  
  Future<void> updateCustomer(Customer customer) async {
    final db = await database;
    await db.update('customers', customer.toMap(), where: 'id = ?', whereArgs: [customer.id]);
  }
  
  Future<void> deleteCustomer(String id) async {
    final db = await database;
    await db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }
  
  // Transaction operations
  Future<void> addTransaction(Transaction transaction) async {
    final db = await database;
    await db.insert('transactions', transaction.toMap());
  }
  
  Future<List<Transaction>> getAllTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('transactions', orderBy: 'transactionDate DESC');
    return List.generate(maps.length, (i) => Transaction.fromMap(maps[i]));
  }
  
  Future<List<Transaction>> getTransactionsByCustomer(String customerId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'customerId = ?',
      whereArgs: [customerId],
      orderBy: 'transactionDate DESC',
    );
    return List.generate(maps.length, (i) => Transaction.fromMap(maps[i]));
  }
  
  Future<List<Transaction>> getTransactionsByDate(DateTime date) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'transactionDate >= ? AND transactionDate <= ?',
      whereArgs: [startOfDay.toIso8601String(), endOfDay.toIso8601String()],
      orderBy: 'transactionDate DESC',
    );
    return List.generate(maps.length, (i) => Transaction.fromMap(maps[i]));
  }
  
  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
    
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'transactionDate >= ? AND transactionDate <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'transactionDate DESC',
    );
    return List.generate(maps.length, (i) => Transaction.fromMap(maps[i]));
  }
  
  Future<void> deleteTransaction(String id) async {
    final db = await database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}
