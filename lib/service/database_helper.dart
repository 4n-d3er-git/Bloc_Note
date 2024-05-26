import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_entrainement/model/note_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "notes.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE  notes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      titre TEXT,
      description TEXT,
      date TEXT
    ) ''');
  }

  Future<int> insererNote(Notes note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<Notes>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return maps.map((map) => Notes.fromMap(map)).toList();
  }

  Future<int> updateNote(Notes note) async {
    final db = await database;
    return await db
        .update('notes', note.toMap(), where: 'id=?', whereArgs: [note.id]);
  }

  Future<int> supprimerNote(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Notes>> Rechercher(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'titre LIKE ?',
      whereArgs: ['%query'],
    );
    return List.generate(maps.length, (index) {
      return Notes(
          id: maps[index]['id'],
          titre: maps[index]['titre'],
          description: maps[index]['description'],
          date: maps[index]['date']);
    });
  }
}
