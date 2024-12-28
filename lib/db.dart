import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:qtcloud_collab_studio/models/task.dart';
import 'package:qtcloud_collab_studio/models/plan.dart';
import 'package:qtcloud_collab_studio/models/vote.dart';

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
    String path = join(await getDatabasesPath(), 'tasks.db');
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
    // 检查 task 表是否存在
    await db.execute('''
      CREATE TABLE IF NOT EXISTS task(
        id TEXT PRIMARY KEY,
        title TEXT, 
        description TEXT,
        owner TEXT,
        reviewer TEXT
      )
    ''');

    // 检查 plan 表是否存在
    await db.execute('''
      CREATE TABLE IF NOT EXISTS plan(
        id TEXT PRIMARY KEY,
        title TEXT, 
        description TEXT,
        owner TEXT,
        reviewer TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS vote(
        id TEXT PRIMARY KEY,
        title TEXT, 
        description TEXT,
        option_1 TEXT,
        option_2 TEXT
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

  Future<void> insertTask(Task task) async {
    try {
      final db = await database;
      if (kDebugMode) {
        print('Task inserting: ${task.toMap()}');
      }
      await db.insert('task', task.toMap());
      if (kDebugMode) {
        print('Task inserted: ${task.toMap()}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting task: $e');
      } // 打印错误信息
    }
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('task');

    // 将查询结果转换为 Task 对象列表
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        owner: maps[i]['owner'],
        reviewer: maps[i]['reviewer'],
      );
    });
  }

  Future<void> deleteTask(String id) async {
    final db = await database;
    if (kDebugMode) {
      print('Deleting task with id: $id'); // 添加调试日志
    }

    final result = await db.delete(
      'task',
      where: 'id = ?',
      whereArgs: [id], // 使用 id 作为条件
    );

    if (kDebugMode) {
      print('Delete result: $result'); // 打印删除结果
    }
  }

  Future<List<Plan>> getPlans() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('plan'); // 查询计划表

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
    await db.insert('plan', plan.toMap()); // 插入计划
  }

  Future<void> updatePlan(Plan plan) async {
    final db = await database;
    await db.update(
      'plan',
      plan.toMap(),
      where: 'id = ?',
      whereArgs: [plan.id], // 使用 id 作为条件
    );
  }

  Future<void> deletePlan(String id) async {
    final db = await database;
    await db.delete(
      'plan',
      where: 'id = ?',
      whereArgs: [id], // 使用 id 作为条件
    );
  }

  Future<void> insertVote(Vote vote) async {
    try {
      final db = await database;
      if (kDebugMode) {
        print('Vote inserting: ${vote.toMap()}');
      }
      await db.insert('vote', vote.toMap());
      if (kDebugMode) {
        print('Vote inserted: ${vote.toMap()}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error inserting vote: $e');
      } // 打印错误信息
    }
  }

  Future<List<Vote>> getVotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('vote');

    // 将查询结果转换为 Vote 对象列表
    return List.generate(maps.length, (i) {
      return Vote(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        option_1: maps[i]['option_1'],
        option_2: maps[i]['option_2'],
      );
    });
  }

  Future<void> deleteVote(String id) async {
    final db = await database;
    if (kDebugMode) {
      print('Deleting vote with id: $id'); // 添加调试日志
    }

    final result = await db.delete(
      'vote',
      where: 'id = ?',
      whereArgs: [id], // 使用 id 作为条件
    );

    if (kDebugMode) {
      print('Delete result: $result'); // 打印删除结果
    }
  }
}
