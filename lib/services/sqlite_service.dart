import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:app_personas/models/person.dart';

class SqliteService {
  static const String databaseName = "people.db";
  static Database? db;

  static Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);
    return db?? await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          await createTables(db);
          print("Database was created!");
        });
  }

  static Future<void> createTables(Database database) async{
    await database.execute(
      'CREATE TABLE IF NOT EXISTS People (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,name TEXT NOT NULL, age INTEGER NOT NULL)'
    );
  }

  Future<int> createPerson(Person person) async {
    final db = await SqliteService.initDb();
    final id = await db.insert('People', person.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    print("Person created! $id");
    return id;
  }

  Future<Person?> getPerson(int id) async {
    final db = await SqliteService.initDb();
    final Future<List<Map<String, dynamic>>> futureMaps = db.query('people', where: 'id = ?', whereArgs: [id]);
    var maps = await futureMaps;
    if (maps.isNotEmpty) {
      return Person.fromDb(maps.first);
    }
    return null;
  }

  Future<List<Person>> getPeople() async {
    final db = await SqliteService.initDb();
    final List<Map<String, Object?>> queryResult = await db.query('People');
    return queryResult.map((e) => Person.fromMap(e)).toList();
  }

  Future<void> updatePerson(Person person) async {
    final db = await SqliteService.initDb();
    try {
      await db.update("People",person.toMap() ,where: "id = ?", whereArgs: [person.id]);
    } catch (err) {
      debugPrint("Something went wrong when update an person: $err");
    }
  }

  Future<void> deletePerson(String id) async {
    final db = await SqliteService.initDb();
    try {
      await db.delete("People", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an person: $err");
    }
  }
}