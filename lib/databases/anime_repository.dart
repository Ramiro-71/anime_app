import 'package:prep_final/models/anime.dart';
import 'package:prep_final/databases/anime_database.dart';
import 'package:sqflite/sqflite.dart';

class AnimeRepository {
  Future insert(Anime anime) async {
    Database db = await AnimeDatabase().openDb();
    db.insert(AnimeDatabase().tableName, anime.toMap());
  }

  Future delete(Anime anime) async {
    Database db = await AnimeDatabase().openDb();
    db.delete(AnimeDatabase().tableName,
        where: "id=?", whereArgs: [anime.malId]);
  }

  Future<bool> isFavorite(Anime anime) async {
    Database db = await AnimeDatabase().openDb();
    final maps = await db.query(AnimeDatabase().tableName,
        where: "id=?", whereArgs: [anime.malId]);
    return maps.isNotEmpty;
  }

  Future<List<Anime>> getAll() async {
    Database db = await AnimeDatabase().openDb();
    final maps = await db.query(AnimeDatabase().tableName);
    return maps.map((map) => Anime.fromMap(map)).toList();
  }
}
