import 'dart:async';

import 'package:tv/data/models/tv_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperTv {
  static DatabaseHelperTv? _databaseHelper;
  DatabaseHelperTv._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelperTv() => _databaseHelper ?? DatabaseHelperTv._instance();

  static Database? _database;

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initDb();
    }
    return _database;
  }

  // static const String _tblWatchlistTv = 'watchlistTv';
  static const String _tblCacheTv = 'cacheTv';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    // await db.execute('''
    //   CREATE TABLE  $_tblWatchlistTv (
    //     id INTEGER PRIMARY KEY,
    //     name TEXT,
    //     overview TEXT,
    //     posterPath TEXT
    //   );
    // ''');
    await db.execute('''
      CREATE TABLE  $_tblCacheTv (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT,
        category TEXT
      );
    ''');
  }

  // Future<int> insertWatchlistTv(TvTable tv) async {
  //   final db = await database;
  //   return await db!.insert(_tblWatchlistTv, tv.toJson());
  // }

  // Future<int> removeWatchlistTv(TvTable tv) async {
  //   final db = await database;
  //   return await db!.delete(
  //     _tblWatchlistTv,
  //     where: 'id = ?',
  //     whereArgs: [tv.id],
  //   );
  // }

  // Future<Map<String, dynamic>?> getTvById(int id) async {
  //   final db = await database;
  //   final results = await db!.query(
  //     _tblWatchlistTv,
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );

  //   if (results.isNotEmpty) {
  //     return results.first;
  //   } else {
  //     return null;
  //   }
  // }

  // Future<List<Map<String, dynamic>>> getWatchlistTvs() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> results = await db!.query(_tblWatchlistTv);

  //   return results;
  // }

  Future<void> insertCacheTransactionTv(
      List<TvTable> tvs, String category) async {
    final db = await database;
    db!.transaction((txn) async {
      for (final tv in tvs) {
        final tvJson = tv.toJson();
        tvJson['category'] = category;
        txn.insert(_tblCacheTv, tvJson);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getCacheTvs(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblCacheTv,
      where: 'category = ?',
      whereArgs: [category],
    );
    return results;
  }

  Future<int> clearCacheTv(String category) async {
    final db = await database;
    return await db!.delete(
      _tblCacheTv,
      where: 'category = ?',
      whereArgs: [category],
    );
  }
}
