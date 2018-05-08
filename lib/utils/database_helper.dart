import 'dart:async';
import 'dart:io';
import 'package:database_intro/models/User.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper{
  static final DatabaseHelper _instance= new DatabaseHelper.internal();

  factory DatabaseHelper()=> _instance;

  final String tableUser = "userTable";
  final String columnId="id";
  final String columnUsername="username";
  final String columnPassword="password";

  static Database _db;
  
  Future<Database> get db async{
    if(_db!=null){
      return _db;
    }
    _db= await initDb();
    return _db;
  }
  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path= join(documentDirectory.path,"maindb.db");

    var our= await openDatabase(path,version: 1, onCreate: _onCreate);
    return our;
  }
  /*
      id | username | password
      -------------------------

  * */


  void _onCreate(Database db, int newVersion) async{
    await db.execute(
      "CREATE TABLE $tableUser($columnId INTEGER PRIMARY KEY, $columnUsername TEXT, $columnPassword TEXT)"
    );
  }
  // CRUD
  Future<int> saveUser(User user) async{
      var dbClient = await db;
      int res= await dbClient.insert("$tableUser",user.toMap());
      return res;
  }
  Future<List> getAllUsers() async{
    var dbClient= await db;
    var result = await dbClient.rawQuery("select * from $tableUser");
    return result.toList();
  }
  Future<int> getCount()async{
    var dbClient= await db;
    return Sqflite.firstIntValue(
      await dbClient.rawQuery("select count(*) from $tableUser")
    );
  }
  Future<User> getUser(int id ) async{
    var dbClient = await db;
    var result= await dbClient.rawQuery("select * from $tableUser where $columnId = $id");
    if(result.length ==0) return null;
    return new User.fromMap(result.first);
  }
  Future<int> deleteUser(int id)async{
    var dbClient =await db;
    return await dbClient.delete(tableUser,
        where:"$columnId = ?",whereArgs: [id]);
  }
  Future<int> updateUser(User user) async{
    var dbClient= await db;
    return dbClient.update(tableUser,
        ,where:"$columnId=?",whereArgs: [user.id]);
  }
  Future close() async{
    var dbClient= await db;
    return dbClient.close();
  }
}