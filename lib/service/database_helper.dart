import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_list/model/task_model.dart';

class DatabaseHelper {
  static const _dbName = 'todo.db';

  static final DatabaseHelper instance = DatabaseHelper.init();

  static Database? _database;
  DatabaseHelper.init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB(_dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE $tableTask(
        ${TaskFields.id} $idType,
        ${TaskFields.title} $textType,
        ${TaskFields.level} $textType
      )''');

    await db.execute('''
      CREATE TABLE $tableTaskComplete(
        ${TaskFields.id} $idType,
        ${TaskFields.title} $textType,
        ${TaskFields.level} $textType
      )''');
  }

  Future<TaskModel> create(String tableName, TaskModel task) async {
    final db = await instance.database;
    final id = await db.insert(tableName, task.toJson());
    return task.copy(id: id);
  }

  Future<TaskModel> read(String tableName, int? id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableName,
      columns: TaskFields.values,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TaskModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<TaskModel>> readAll(String tableName) async {
    final db = await instance.database;
    final result = await db.query(tableName);
    return result.map((json) => TaskModel.fromJson(json)).toList();
  }

  update(String tableName, TaskModel taskModel) async {
    final db = await instance.database;
    try {
      db.rawUpdate('''
    UPDATE ${tableName} 
    SET ${TaskFields.title} = ?, ${TaskFields.level} = ?
    WHERE ${TaskFields.id} = ?
    ''', [taskModel.title, taskModel.level, taskModel.id]);
    } catch (e) {
      print('error: ' + e.toString());
    }
  }

  delete(String tableName, int? id) async {
    final db = await instance.database;
    try {
      await db.delete(
        tableName,
        where: '${TaskFields.id} = ?',
        whereArgs: [id],
      );
      print("finish");
    } catch (e) {
      print(e);
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
