import 'package:ask_list_app/model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String modelTable = 'model_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {

    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'models.db';

    var todosDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return todosDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $modelTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
        '$colDescription TEXT)');
  }

  Future<List<Map<String, dynamic>>> getModelMapList() async {
    Database db = await this.database;

    var result = await db.query(modelTable, orderBy: '$colTitle ASC');
    return result;
  }

  Future<int> insertModel(Model model) async {
    Database db = await this.database;
    var result = await db.insert(modelTable, model.toMap());
    return result;
  }

  Future<int> updateModel(Model model) async {
    var db = await this.database;
    var result = await db.update(modelTable, model.toMap(), where: '$colId = ?', whereArgs: [model.id]);
    return result;
  }

  Future<int> updateModelCompleted(Model model) async {
    var db = await this.database;
    var result = await db.update(modelTable, model.toMap(), where: '$colId = ?', whereArgs: [model.id]);
    return result;
  }

  Future<int> deleteModel(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $modelTable WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $modelTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Model>> getModelList() async {

    var todoMapList = await getModelMapList();
    int count = todoMapList.length;

    List<Model> todoList = List<Model>();
    // For loop to create a 'todo List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      todoList.add(Model.fromMapObject(todoMapList[i]));
    }
    return todoList;
  }

}