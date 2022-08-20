import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uno_point_sale/db/model/note.dart';

class AppDatabase{
  static final AppDatabase  instance = AppDatabase._init();
  static Database? _database;
  AppDatabase._init();

  Future<Database> get database async {
    if(_database != null)return _database!;
    _database = await _initDB("AppDatabase.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path,version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async{
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute(''
        ' CREATE TABLE $tableNotes('
        ' ${NoteFields.id} $idType,'
        ' ${NoteFields.isImportant} $boolType,'
        ' ${NoteFields.number} $integerType,'
        ' ${NoteFields.title} $textType,'
        ' ${NoteFields.time} $textType,'
        ' ${NoteFields.description} $textType '
        ') ;');

  }

  Future<Note> create(Note note) async{
    final db = await instance.database;
    // final json = note.toJson();
    // final columns =
    //     '${NoteFields.title}, ${NoteFields.description}, ${NoteFields.time}';
    // final values =
    //     '${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<int> update(Note note) async{
    final db = await instance.database;
    //db.rawUpdate(sql)
    return db.update(tableNotes,
        note.toJson(),
        where: '${NoteFields.id}=?',
        whereArgs: [note.id]
    );
  }

  Future<int> delete(int id) async{
    final db = await instance.database;
    return await db.delete(tableNotes,
     where:  '${NoteFields.id}=?',
    whereArgs: [id]);
  }

  Future<List<Note>> readAllNotes() async{
    final db = await instance.database;
    final result = await db.query(tableNotes);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<Note> readNote(int id) async{
    final db = await instance.database;

    final maps = await db.query(
        tableNotes,
       columns: NoteFields.value,
      where: '${NoteFields.id}=?',
      whereArgs: [id]
    );

    if(maps.isNotEmpty){
      return Note.fromJson(maps.first);
    }else{
      throw Exception('ID $id not found');
    }
  }

  Future close() async{
    final db = await instance.database;
    db.close();
  }
}
