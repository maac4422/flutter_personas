import 'package:app_personas/services/sqlite_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:app_personas/models/person_hobby.dart';

class PersonHobbyService {
  SqliteService sqliteService = SqliteService();
  static const tableName = 'Hobby_People';

  Future<int> createPersonHobby(PersonHobby personHobby) async {
    final db = await sqliteService.initDb();
    final id = await db.insert(tableName, personHobby.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    print("Hobby_People created! $id");
    return id;
  }

  Future<PersonHobby?> getAllHobbiesFromPerson(int id) async {
    final db = await sqliteService.initDb();
    final Future<List<Map<String, dynamic>>> futureMaps = db.query(tableName, where: 'id = ?', whereArgs: [id]);
    var maps = await futureMaps;
    if (maps.isNotEmpty) {
      return PersonHobby.fromDb(maps.first);
    }
    return null;
  }

  Future<List<PersonHobby>> getHobbies() async {
    final db = await sqliteService.initDb();
    final List<Map<String, Object?>> queryResult = await db.query(tableName);
    return queryResult.map((e) => PersonHobby.fromMap(e)).toList();
  }

  Future<void> deletePersonHobby(int id) async {
    final db = await sqliteService.initDb();
    try {
      await db.delete(tableName, where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an person hobby: $err");
    }
  }
}