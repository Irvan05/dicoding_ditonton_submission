import 'dart:async';

import 'package:movie/movie.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tv/tv.dart';

class DatabaseHelperWatchlist {
  static DatabaseHelperWatchlist? _databaseHelper;
  DatabaseHelperWatchlist._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelperWatchlist() =>
      _databaseHelper ?? DatabaseHelperWatchlist._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblWatchlistMovie = 'watchlistMovie';
  static const String _tblWatchlistTv = 'watchlistTv';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    var db = await openDatabase(databasePath, version: 1);
    partialCreate(db);
    return db;
  }

  void partialCreate(Database db) {
    db.execute('''CREATE TABLE IF NOT EXISTS $_tblWatchlistMovie (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );''');
    db.execute('''CREATE TABLE IF NOT EXISTS $_tblWatchlistTv (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );''');
  }

  Future<int> insertWatchlistMovie(MovieTable movie) async {
    final db = await database;
    return await db!.insert(_tblWatchlistMovie, movie.toJson());
  }

  Future<int> insertWatchlistTv(TvTable tv) async {
    final db = await database;
    return await db!.insert(_tblWatchlistTv, tv.toJson());
  }

  Future<int> removeWatchlistMovie(MovieTable movie) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlistMovie,
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<int> removeWatchlistTv(TvTable tv) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlistTv,
      where: 'id = ?',
      whereArgs: [tv.id],
    );
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlistMovie,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getTvById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlistTv,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> results =
        await db!.query(_tblWatchlistMovie);

    return results;
  }

  Future<List<Map<String, dynamic>>> getWatchlistTvs() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tblWatchlistTv);

    return results;
  }
}
