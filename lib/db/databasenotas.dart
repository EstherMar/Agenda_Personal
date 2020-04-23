import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';
import 'classnota.dart';

class NotasDatabaseProvider{
  NotasDatabaseProvider._();

  static final  NotasDatabaseProvider db = NotasDatabaseProvider._();
  Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "notas.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
            await db.execute("CREATE TABLE notas ("
                              "id integer primary key,"
                              "titulo TEXT,"
                              "descripcion TEXT"")");
        });
  }

  Future<List<classnota>> getAllNotas() async {
    final db = await database;
    var response = await db.query("notas");
    List<classnota> list = response.map((c) => classnota.fromMap(c)).toList();
    return list;
  }

  Future<classnota> getNotasWithId(int id) async {
    final db = await database;
    var response = await db.query("notas", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? classnota.fromMap(response.first) : null;
  }

  addNotasToDatabase(classnota _classnota) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM notas");
    int id = table.first["id"];
    _classnota.id = id;
    var raw = await db.insert(
      "notas",
      _classnota.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,);
    return raw;
  }

  deleteNotasWithId(int id) async {
    final db = await database;
    return db.delete("notas", where: "id = ?", whereArgs: [id]);
  }

  deleteAllNotas() async {
    final db = await database;
    db.delete("notas");
  }

  updateNotas(classnota _classnota) async {
    final db = await database;
    var response = await db.update("notas", _classnota.toMap(),
        where: "id = ?", whereArgs: [_classnota.id]);
        return response;
  }
}