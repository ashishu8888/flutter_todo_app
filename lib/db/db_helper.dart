import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'ToDo.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        ''' CREATE TABLE ToDo(id INTEGER PRIMARY KEY, title STRING, note TEXT, date STRING, color INTEGER,isCompleted INTEGER)''');
  }

  Future<List<Task>> getToDo() async {
    Database db = await instance.database;

    // ignore: non_constant_identifier_names
    var ToDos = await db.query('ToDo', orderBy: 'id');

    List<Task> toDoList =
        ToDos.isNotEmpty ? ToDos.map((c) => Task.fromMap(c)).toList() : [];
    return toDoList;
  }

  Future<int> add(Task ToDo) async {
    Database db = await instance.database;
    return await db.insert('ToDo', ToDo.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    print('removed $id');
    return await db.delete('ToDo', where: 'id =?', whereArgs: [id]);
  }

  Future<int> update(Task ToDo) async {
    Database db = await instance.database;
    return await db
        .update('ToDo', ToDo.toMap(), where: 'id = ?', whereArgs: [ToDo.id]);
  }
}
