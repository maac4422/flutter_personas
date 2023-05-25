import 'package:app_personas/services/sqlite_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:app_personas/models/hobby.dart';

class HobbyService {
  SqliteService sqliteService = SqliteService();
  static const tableName = 'Hobbies';

  Future<int> createHobby(Hobby hobby) async {
    final db = await sqliteService.initDb();
    final id = await db.insert(tableName, hobby.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    print("Hobby created! $id");
    return id;
  }

  Future<Hobby?> getHobby(int id) async {
    final db = await sqliteService.initDb();
    final Future<List<Map<String, dynamic>>> futureMaps = db.query(tableName, where: 'id = ?', whereArgs: [id]);
    var maps = await futureMaps;
    if (maps.isNotEmpty) {
      return Hobby.fromDb(maps.first);
    }
    return null;
  }

  Future<List<Hobby>> getHobbies() async {
    final db = await sqliteService.initDb();
    final List<Map<String, Object?>> queryResult = await db.query(tableName);
    return queryResult.map((e) => Hobby.fromMap(e)).toList();
  }
}