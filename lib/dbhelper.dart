import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflitedeneme/note.dart';

class DbHelper {
  Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database?> initializeDb() async {
    String dbPath = join(await getDatabasesPath(), "notes.db");
    var notesDb = await openDatabase(dbPath, version: 1, onCreate: createDb);
    return notesDb;
  }

  Future<void> createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, content TEXT)');
  }

  Future<List<Note>> getNotes() async {
    Database? db = await this.db;
    var result = await db!.query("notes");
    return List.generate(
        result.length, (index) => Note.fromObject(result[index]));
  }

  Future<int?> insertNote(Note newNote) async {
    Database? db = await this.db;
    var result = await db!.insert("notes", newNote.toMap(newNote));
    return result;
  }

  Future<int?> deleteNote(int id) async {
    Database? db = await this.db;
    var result = await db!.delete("notes", where: 'id=?', whereArgs: [id]);
    return result;
  }

  Future<int?> updateNote(Note updatedNote) async {
    Database? db = await this.db;
    var result = await db!.update("notes", updatedNote.toMap(updatedNote),
        where: "id=?", whereArgs: [updatedNote.id]);
    return result;
  }
}
