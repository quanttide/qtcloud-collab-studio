import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:qtcloud_collab_studio/models/action.dart';
import 'package:qtcloud_collab_studio/models/plan.dart';


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
    // 检查数据库是否存在
    final exists = await databaseExists(path);
    if (!exists) {
      // 如果数据库不存在，创建数据库
      return await openDatabase(path, version: 1, onCreate: _createDatabase);
    } else {
      // 如果数据库已存在，直接打开数据库
      return await openDatabase(path);
    }
  }

  Future<void> _createDatabase(Database db, int version) async {
    // 检查 actions 表是否存在
    await db.execute('''
      CREATE TABLE IF NOT EXISTS actions(
        id TEXT PRIMARY KEY,
        title TEXT, 
        description TEXT
        owner TEXT,
        reviewer TEXT
      )
    ''');
    
    // 检查 plans 表是否存在
    await db.execute('''
      CREATE TABLE IF NOT EXISTS plans(
        id TEXT PRIMARY KEY,
        title TEXT, 
        description TEXT
        owner TEXT,
        reviwer TEXT,
      )
    ''');
    
    if (kDebugMode) {
      print('Database created or already exists');
    } // 确认数据库创建或已存在
  }

  Future<bool> databaseExists(String path) async {
    final file = File(path);
    return await file.exists();
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
        owner: maps[i]['owner'],
        reviewer: maps[i]['reviewer'],
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

  Future<List<Plan>> getPlans() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('plans'); // 查询计划表
    
    // 将查询结果转换为 Plan 对象列表
    return List.generate(maps.length, (i) {
      return Plan(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
      );
    });
  }

  Future<void> insertPlan(Plan plan) async {
    final db = await database;
    await db.insert('plans', plan.toMap()); // 插入计划
  }

  Future<void> updatePlan(Plan plan) async {
    final db = await database;
    await db.update(
      'plans',
      plan.toMap(),
      where: 'id = ?',
      whereArgs: [plan.id], // 使用 id 作为条件
    );
  }

  Future<void> deletePlan(String id) async {
    final db = await database;
    await db.delete(
      'plans',
      where: 'id = ?',
      whereArgs: [id], // 使用 id 作为条件
    );
  }
}
