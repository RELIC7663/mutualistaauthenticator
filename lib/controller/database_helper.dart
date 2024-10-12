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

  Future<int> deleteAllEntries() async {
    var db = await this.database;
    int result = await db.delete(userTable);
    return result;


  }

    Future<void> update_NUM_INTENTOS_Dbenty(String value) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.database;
    await databaseHelper.updateDbenty(Dbenty(keys: 'NUM_INTENTOS', value: value));
  }

  Future<void> update_Token_Dbenty(String value) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.database;
    await databaseHelper.updateDbenty(Dbenty(keys: 'TOKEN', value: value));
  }

  Future<int> getNumIntentos() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.database;
    List<Dbenty> userList = await databaseHelper.getDbenty();
    
    // Buscar la entrada que tenga 'NUM_INTENTOS' como clave
    Dbenty? numIntentosEntry = userList.firstWhere(
      (entry) => entry.keys == 'NUM_INTENTOS', 
      orElse: () => Dbenty(keys: 'NUM_INTENTOS', value: '0') // Retornar '0' si no se encuentra
    );

    // Convertir el valor a entero
    return int.tryParse(numIntentosEntry.value ?? '0') ?? 0; 
  }

  Future<String> getToken() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.database;
    List<Dbenty> userList = await databaseHelper.getDbenty();
    
    // Buscar la entrada que tenga 'NUM_INTENTOS' como clave
    Dbenty? numIntentosEntry = userList.firstWhere(
      (entry) => entry.keys == 'TOKEN', 
      orElse: () => Dbenty(keys: 'TOKEN', value: '0') // Retornar '0' si no se encuentra
    );

    
    return numIntentosEntry.value;
  }

  Future<int> getUSER() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.database;
    List<Dbenty> userList = await databaseHelper.getDbenty();
    
    // Buscar la entrada que tenga 'USER_ID' como clave
    Dbenty? numIntentosEntry = userList.firstWhere(
      (entry) => entry.keys == 'USER_ID', 
      orElse: () => Dbenty(keys: 'USER_ID', value: '0') // Retornar '0' si no se encuentra
    );
    return int.tryParse(numIntentosEntry.value ?? '0') ?? 0; 
  }


}
