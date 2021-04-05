import 'dart:io';

import 'package:listac/models/task_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database _db;
  DatabaseHelper._instance();

  String taskTable = 'task_table';
  String colId = 'id';
  String colTitle = 'title';
  String colTgl = 'tgl';
  String colPriority = 'priority';
  String colStatus = 'status';

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'todo_list.db';
    final todoListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);

    return todoListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $taskTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colTgl TEXT, $colPriority TEXT, $colStatus INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> rs = await db.query(taskTable);
    return rs;
  }

  Future<List<Task>> getTaskList() async {
    final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
    final List<Task> taskList = [];
    taskMapList.forEach((taskMap) {
      taskList.add(Task.fromMap(taskMap));
    });

    return taskList;
  }

  Future<int> insertTask(Task task) async {
    Database db = await this.db;
    final int res = await db.insert(taskTable, task.toMap());
    return res;
  }

  Future<int> updateTask(Task task) async {
    Database db = await this.db;
    final int res = await db.update(taskTable, task.toMap(),
        where: '$colId = ?', whereArgs: [task.id]);
    return res;
  }

  Future<int> deleteTask(int id) async {
    Database db = await this.db;
    final int res =
        await db.delete(taskTable, where: '$colId = ?', whereArgs: [id]);
    return res;
  }
}
