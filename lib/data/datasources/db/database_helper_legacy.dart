// import 'dart:async';

// import 'package:ditonton/data/models/movie_table.dart';
// import 'package:ditonton/data/models/tv_table.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseHelper {
//   static DatabaseHelper? _databaseHelper;
//   DatabaseHelper._instance() {
//     _databaseHelper = this;
//   }

//   factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

//   static Database? _database;

//   Future<Database?> get database async {
//     if (_database == null) {
//       _database = await _initDb();
//     }
//     return _database;
//   }

//   static const String _tblWatchlistMovie = 'watchlist';
//   static const String _tblCacheMovie = 'cache';
//   static const String _tblWatchlistTv = 'watchlistTv';
//   static const String _tblCacheTv = 'cacheTv';

//   Future<Database> _initDb() async {
//     final path = await getDatabasesPath();
//     final databasePath = '$path/ditonton.db';

//     var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
//     return db;
//   }

//   void _onCreate(Database db, int version) async {
//     await db.execute(
//         '''
//       CREATE TABLE  $_tblWatchlistMovie (
//         id INTEGER PRIMARY KEY,
//         title TEXT,
//         overview TEXT,
//         posterPath TEXT
//       );
//     ''');
//     await db.execute(
//         '''
//       CREATE TABLE  $_tblCacheMovie (
//         id INTEGER PRIMARY KEY,
//         title TEXT,
//         overview TEXT,
//         posterPath TEXT,
//         category TEXT
//       );
//     ''');
//     await db.execute(
//         '''
//       CREATE TABLE  $_tblWatchlistTv (
//         id INTEGER PRIMARY KEY,
//         name TEXT,
//         overview TEXT,
//         posterPath TEXT
//       );
//     ''');
//     await db.execute(
//         '''
//       CREATE TABLE  $_tblCacheTv (
//         id INTEGER PRIMARY KEY,
//         name TEXT,
//         overview TEXT,
//         posterPath TEXT,
//         category TEXT
//       );
//     ''');
//   }

//   Future<int> insertWatchlistMovie(MovieTable movie) async {
//     final db = await database;
//     return await db!.insert(_tblWatchlistMovie, movie.toJson());
//   }

//   Future<int> insertWatchlistTv(TvTable tv) async {
//     final db = await database;
//     return await db!.insert(_tblWatchlistTv, tv.toJson());
//   }

//   Future<int> removeWatchlistMovie(MovieTable movie) async {
//     final db = await database;
//     return await db!.delete(
//       _tblWatchlistMovie,
//       where: 'id = ?',
//       whereArgs: [movie.id],
//     );
//   }

//   Future<int> removeWatchlistTv(TvTable tv) async {
//     final db = await database;
//     return await db!.delete(
//       _tblWatchlistTv,
//       where: 'id = ?',
//       whereArgs: [tv.id],
//     );
//   }

//   Future<Map<String, dynamic>?> getMovieById(int id) async {
//     final db = await database;
//     final results = await db!.query(
//       _tblWatchlistMovie,
//       where: 'id = ?',
//       whereArgs: [id],
//     );

//     if (results.isNotEmpty) {
//       return results.first;
//     } else {
//       return null;
//     }
//   }

//   Future<Map<String, dynamic>?> getTvById(int id) async {
//     final db = await database;
//     final results = await db!.query(
//       _tblWatchlistTv,
//       where: 'id = ?',
//       whereArgs: [id],
//     );

//     if (results.isNotEmpty) {
//       return results.first;
//     } else {
//       return null;
//     }
//   }

//   Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
//     final db = await database;
//     final List<Map<String, dynamic>> results =
//         await db!.query(_tblWatchlistMovie);

//     return results;
//   }

//   Future<List<Map<String, dynamic>>> getWatchlistTvs() async {
//     final db = await database;
//     final List<Map<String, dynamic>> results = await db!.query(_tblWatchlistTv);

//     return results;
//   }

//   Future<void> insertCacheTransactionMovie(
//       List<MovieTable> movies, String category) async {
//     final db = await database;
//     db!.transaction((txn) async {
//       for (final movie in movies) {
//         final movieJson = movie.toJson();
//         movieJson['category'] = category;
//         txn.insert(_tblCacheMovie, movieJson);
//       }
//     });
//   }

//   Future<void> insertCacheTransactionTv(
//       List<TvTable> tvs, String category) async {
//     final db = await database;
//     db!.transaction((txn) async {
//       for (final tv in tvs) {
//         final tvJson = tv.toJson();
//         tvJson['category'] = category;
//         txn.insert(_tblCacheTv, tvJson);
//       }
//     });
//   }

//   Future<List<Map<String, dynamic>>> getCacheMovies(String category) async {
//     final db = await database;
//     final List<Map<String, dynamic>> results = await db!.query(
//       _tblCacheMovie,
//       where: 'category = ?',
//       whereArgs: [category],
//     );
//     return results;
//   }

//   Future<List<Map<String, dynamic>>> getCacheTvs(String category) async {
//     final db = await database;
//     final List<Map<String, dynamic>> results = await db!.query(
//       _tblCacheTv,
//       where: 'category = ?',
//       whereArgs: [category],
//     );
//     return results;
//   }

//   Future<int> clearCacheMovie(String category) async {
//     final db = await database;
//     return await db!.delete(
//       _tblCacheMovie,
//       where: 'category = ?',
//       whereArgs: [category],
//     );
//   }

//   Future<int> clearCacheTv(String category) async {
//     final db = await database;
//     return await db!.delete(
//       _tblCacheTv,
//       where: 'category = ?',
//       whereArgs: [category],
//     );
//   }
// }
