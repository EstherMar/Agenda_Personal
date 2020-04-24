import 'dart:io';
import 'package:miagendapersonal/db/classevento.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';

class EventosDatabaseProvider{
  EventosDatabaseProvider._();

  static final  EventosDatabaseProvider db = EventosDatabaseProvider._();
  Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "eventos.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE eventos ("
              "id INTEGER PRIMARY KEY, "
              "fechareal TEXT,"
              "fecha TEXT,"
              "hora TEXT,"
              "tipoevento TEXT, "
              "titulo TEXT,"
              "descripcion TEXT"
              ")");
        });
  }

  Future<List<classevento>> getAllEventos() async {
    final db = await database;
    var response = await db.query("eventos");
    List<classevento> list = response.map((c) => classevento.fromMap(c)).toList();
    return list;
  }

  Future<List<classevento>> getAllFechareal() async {
    final db = await database;
    var response = await db.rawQuery("SELECT fechareal FROM eventos");
    List<classevento> list = response.map((c) => classevento.fromMap(c)).toList();
    return list;
  }

  Future<List<classevento>> getEventosWithFecha(String fecha) async {
    final db = await database;
    var response = await db.query("eventos", where: "fecha = ?", whereArgs: [fecha]);
    List<classevento> list = response.map((c) => classevento.fromMap(c)).toList();
    return list;
  }

  Future<List<classevento>> getEventosWithTipo(String tipo) async {
    final db = await database;
    var response = await db.query("eventos", where: "tipoevento = ?", whereArgs: [tipo]);
    List<classevento> list = response.map((c) => classevento.fromMap(c)).toList();
    return list;
  }

  Future<classevento> getEventosWithId(int id) async {
    final db = await database;
    var response = await db.query("eventos", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? classevento.fromMap(response.first) : null;
  }

  addEventosToDatabase(classevento _classevento) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM eventos");
    int id = table.first["id"];
    _classevento.id = id;
    var raw = await db.insert(
      "eventos",
      _classevento.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,);
    return raw;
  }

  deleteEventosWithId(int id) async {
    final db = await database;
    return db.delete("eventos", where: "id = ?", whereArgs: [id]);
  }

  deleteAllEventos() async {
    final db = await database;
    db.delete("eventos");
  }

  updateEventos(classevento _classevento) async {
    final db = await database;
    var response = await db.update("eventos", _classevento.toMap(),
        where: "id = ?", whereArgs: [_classevento.id]);
    return response;
  }
}
