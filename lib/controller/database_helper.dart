import 'dart:async';
import 'package:mutualistaauthenticator/Model/dbenty.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  String userTable = 'dbenty';
  String colKeys = 'keys';
  String colValue = 'value';

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
    String path = join(await getDatabasesPath(), 'dbenty.db');
    var dbentyDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);

    return dbentyDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $userTable($colKeys TEXT PRIMARY KEY, $colValue TEXT DEFAULT "0")');
  }

  Future<int> insertDbenty(Dbenty user) async {
    Database db = await this.database;
    var result = await db.insert(userTable, user.toMap());
    return result;
  }

  Future<List<Dbenty>> getDbenty() async {
    Database db = await this.database;
    var result = await db.query(userTable);
    List<Dbenty> userList = result.map((item) => Dbenty.fromMap(item)).toList();
    return userList;
  }

  Future<int> updateDbenty(Dbenty user) async {
    var db = await this.database;
    var result = await db.update(userTable, user.toMap(),
        where: '$colKeys = ?', whereArgs: [user.keys]);
    return result;
  }

  Future<int> deleteEnty(String id) async {
    var db = await this.database;
    int result =
        await db.delete(userTable, where: '$colKeys = ?', whereArgs: [id]);
    return result;
  }
}
