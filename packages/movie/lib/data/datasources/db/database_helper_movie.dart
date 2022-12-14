import 'dart:async';

import 'package:movie/data/models/movie_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperMovie {
  static DatabaseHelperMovie? _databaseHelper;
  DatabaseHelperMovie._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelperMovie() =>
      _databaseHelper ?? DatabaseHelperMovie._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblCacheMovie = 'cache';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    var db = await openDatabase(databasePath, version: 1);
    partialCreate(db);
    return db;
  }

  void partialCreate(Database db) {
    db.execute('''CREATE TABLE IF NOT EXISTS $_tblCacheMovie (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT,
        category TEXT
      );''');
  }

  Future<void> insertCacheTransactionMovie(
      List<MovieTable> movies, String category) async {
    final db = await database;

    db!.transaction((txn) async {
      for (final movie in movies) {
        final movieJson = movie.toJson();
        movieJson['category'] = category;
        txn.insert(_tblCacheMovie, movieJson);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getCacheMovies(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblCacheMovie,
      where: 'category = ?',
      whereArgs: [category],
    );
    return results;
  }

  Future<int> clearCacheMovie(String category) async {
    final db = await database;
    return await db!.delete(
      _tblCacheMovie,
      where: 'category = ?',
      whereArgs: [category],
    );
  }
}
