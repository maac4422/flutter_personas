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

  Future<List<PersonHobby>> getAllHobbiesFromPerson(int id) async {
    final db = await sqliteService.initDb();
    final List<Map<String, Object?>> queryResult = await db.query(tableName, where: 'personId = ?', whereArgs: [id]);
    return queryResult.map((e) => PersonHobby.fromMap(e)).toList();
  }

  Future<List<PersonHobby>> getHobbies() async {
    final db = await sqliteService.initDb();
    final List<Map<String, Object?>> queryResult = await db.query(tableName);
    return queryResult.map((e) => PersonHobby.fromMap(e)).toList();
  }

  Future<void> deletePersonHobby(int personId, int hobbyId) async {
    final db = await sqliteService.initDb();
    try {
      await db.delete(tableName, where: "personId = ?, hobbyId = '", whereArgs: [personId, hobbyId]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an person hobby: $err");
    }
  }

  Future<List<Map>?> getHobbiesStatistics() async {
    final db = await sqliteService.initDb();
    try {
      List<Map> result = await db.rawQuery('''
          SELECT LOWER(h.name) AS hobby_name, COUNT(*) AS hobby_count,
          COUNT(DISTINCT ph.personId) AS person_count
      FROM Hobbies h
      JOIN Hobby_People ph ON h.id = ph.hobbyId
      GROUP BY LOWER(h.name)
      ORDER BY hobby_count DESC
      ''');
      return result;
    } catch (err) {
      debugPrint("Something went wrong when deleting an person hobby: $err");
    }
    return null;
  }
}