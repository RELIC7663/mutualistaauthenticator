import 'dart:async';
import 'package:mutualistaauthenticator/Model/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  String userTable = 'user';
  String colId = 'id';
  String colPin = 'pin';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper!;
  }

  bool _isDatabaseInitialized = false;

  Future<Database> get database async {
    if (_database == null || !_isDatabaseInitialized) {
      _database = await initializeDatabase();
      _isDatabaseInitialized = true;
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'user.db');
    var userDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);

    return userDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $userTable($colId TEXT PRIMARY KEY, $colPin TEXT DEFAULT "0")');
  }

  Future<int> insertUser(User user) async {
    Database db = await this.database;
    var result = await db.insert(userTable, user.toMap());
    return result;
  }

  Future<List<User>> getUsers() async {
    Database db = await this.database;
    var result = await db.query(userTable);
    List<User> userList = result.map((item) => User.fromMap(item)).toList();
    return userList;
  }

  Future<int> updateUserPin(User user) async {
    var db = await this.database;
    var result = await db.update(userTable, user.toMap(),
        where: '$colId = ?', whereArgs: [user.id]);
    return result;
  }

  Future<int> deleteUser(String id) async {
    var db = await this.database;
    int result =
        await db.delete(userTable, where: '$colId = ?', whereArgs: [id]);
    return result;
  }
}
