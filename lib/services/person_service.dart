import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:app_personas/services/sqlite_service.dart';
import 'package:app_personas/models/person.dart';

class PersonService {
  SqliteService sqliteService = SqliteService();
  static const tableName = 'People';

  Future<int> createPerson(Person person) async {
    final db = await sqliteService.initDb();
    final id = await db.insert(tableName, person.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    print("Person created! $id");
    return id;
  }

  Future<Person?> getPerson(int id) async {
    final db = await sqliteService.initDb();
    final Future<List<Map<String, dynamic>>> futureMaps = db.query(tableName, where: 'id = ?', whereArgs: [id]);
    var maps = await futureMaps;
    if (maps.isNotEmpty) {
      return Person.fromDb(maps.first);
    }
    return null;
  }

  Future<List<Person>> getPeople() async {
    final db = await sqliteService.initDb();
    final List<Map<String, Object?>> queryResult = await db.query(tableName);
    return queryResult.map((e) => Person.fromMap(e)).toList();
  }

  Future<int> updatePerson(Person person) async {
    final db = await sqliteService.initDb();
    late int result;
    try {
      result = await db.update(tableName,person.toMap() ,where: "id = ?", whereArgs: [person.id]);
    } catch (err) {
      debugPrint("Something went wrong when update an person: $err");
    }
    return result;
  }

  Future<void> deletePerson(int id) async {
    final db = await sqliteService.initDb();
    try {
      await db.delete(tableName, where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an person: $err");
    }
  }
}