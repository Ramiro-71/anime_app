import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AnimeDatabase {
  final int version = 1;
  final String databaseName = "anime.db";
  final String tableName = "animes";

  Database? db;

  Future<Database> openDb() async {
    db ??= await openDatabase(join(await getDatabasesPath(), databaseName),
        onCreate: (database, version) {
      database.execute(
          "create table $tableName (id integer primary key, title text, imageUrl text, year integer, episodes integer, members integer)");
    }, version: version);
    return db as Database;
  }
}
