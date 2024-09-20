import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:qtcloud_collab_studio/models/action.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'actions.db');
    if (kDebugMode) {
      print('Database path: $path');
    } // 打印数据库路径
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE actions(
        id TEXT PRIMARY KEY,
        title TEXT, 
        description TEXT
      )
    ''');
    if (kDebugMode) {
      print('Database created');
    } // 确认数据库创建
  }

  Future<void> insertAction(Action action) async {
    try {
      final db = await database;
      if (kDebugMode) {
        print('Action inserting: ${action.toMap()}');
      }
      await db.insert('actions', action.toMap());
      if (kDebugMode) {
        print('Action inserted: ${action.toMap()}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting action: $e');
      } // 打印错误信息
    }
  }

  Future<List<Action>> getActions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('actions');
    
    // 将查询结果转换为 Action 对象列表
    return List.generate(maps.length, (i) {
      return Action(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
      );
    });
  }

  Future<void> deleteAction(String id) async {
    final db = await database;
    if (kDebugMode) {
      print('Deleting action with id: $id'); // 添加调试日志
    }
    
    final result = await db.delete(
      'actions',
      where: 'id = ?',
      whereArgs: [id], // 使用 id 作为条件
    );

    if (kDebugMode) {
      print('Delete result: $result'); // 打印删除结果
    }
  }

  // 其他数据库操作...
}
