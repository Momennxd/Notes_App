import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/utils/utils.dart' as Sql;
import './note.dart';

class NotesManager {
  static final NotesManager _instance = NotesManager._internal();
  NotesManager._internal();
  factory NotesManager() => _instance;

  Database? _db;

  Future<Database> get _database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'notes.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE notes (
            id      INTEGER PRIMARY KEY AUTOINCREMENT,
            title   TEXT    NOT NULL,
            content TEXT    NOT NULL,
            icon    INTEGER NOT NULL,
            date    TEXT    NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<Note>> get notes async {
    final db = await _database;
    final maps = await db.query('notes');
    return maps.map((m) => Note.fromMap(m)).toList();
  }

  Future<Note> addNote(String title, String content, IconData icon) async {
    final db = await _database;
    final id = await db.insert('notes', {
      'title': title,
      'content': content,
      'icon': icon.codePoint,
      'date': DateTime.now().toIso8601String(),
    });
    return Note(id: id, title: title, content: content, icon: icon, date: DateTime.now());
  }

  Future<bool> deleteNote(int id) async {
    final db = await _database;
    final count = await db.delete('notes', where: 'id = ?', whereArgs: [id]);
    return count > 0;
  }

  Future<Note?> getNote(int id) async {
    final db = await _database;
    final maps = await db.query('notes', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Note.fromMap(maps.first);
  }

  Future<bool> updateNote(int id, {String? title, String? content, IconData? icon}) async {
    final db = await _database;
    final note = await getNote(id);
    if (note == null) return false;
    final updated = note.copyWith(title: title, content: content, icon: icon);

    // ✅ remove id from map before updating
    final map = updated.toMap();
    map.remove('id');

    final count = await db.update(
      'notes',
      map,
      where: 'id = ?',
      whereArgs: [id],
    );
    return count > 0;
  }

  Future<int> get length async {
    final db = await _database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM notes');
    return Sql.firstIntValue(result) ?? 0;
  }
}