import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class DatabaseHelper {

  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  late Database _database;

  Future<Database> get db async {
    if (_database != null) {
      return _database;
    }
    _database = await initDb();
    return _database;
  }

  DatabaseHelper.internal();
  initDb() async {
    var path  =  join(await getDatabasesPath(),"song.db");
      _database = await openDatabase(path,version: 1, onCreate: (Database db,int version)async{
        await db.execute("CREATE TABLE SongList(id INTEGER PRIMARY KEY,songname TEXT)");
      });
  }
  Future<int> insertdata(String song) async{
    await initDb();
    print('----++++----++++ Database File ++++----++++--- $song');
    return await _database.insert("SongList",{"songname": song});
  }

  Future<List> readalldata() async{
    await initDb();
    List<Map<String,dynamic>> lstsong = await _database.query("SongList");
    print(lstsong);
    return lstsong;
  }

}