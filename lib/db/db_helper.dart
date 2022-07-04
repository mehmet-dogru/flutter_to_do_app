import 'package:flutter_to_do_app/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = "tasks";

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'tasks.db';
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE $_tableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title TEXT, note TEXT, date TEXT, "
            "startTime TEXT, endTime TEXT, "
            "remind INTEGER, repeat TEXT, "
            "color INTEGER, "
            "isCompleted INTEGER)",
          );
        },
      );

      print("Database oluşturuldu.");
    } catch (e) {
      print(e.toString());
    }
  }

  static Future insert(Task? task) async {
    return await _db?.insert(_tableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(_tableName);
  }

  static delete(Task task) async {
    return await _db?.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static update(int id) async {
    return await _db!.rawUpdate(
      '''
    UPDATE tasks
    SET isCompleted = ?
    WHERE id = ?
    ''',
      [1, id],
    );
  }
}
