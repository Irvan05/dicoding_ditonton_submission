import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:watchlist/data/datasources/db/database_helper_watchlist.dart';

import '../../dummy_data/dummy_objects.dart';

void sqfliteTestInit() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

Future main() async {
  late DatabaseHelperWatchlist databaseHelperWatchlist;

  setUp(() {
    databaseHelperWatchlist = DatabaseHelperWatchlist();
  });

  sqfliteTestInit();
  test('insertWatchlistMovie', () async {
    var db = await openDatabase(inMemoryDatabasePath);
    await db.execute('''
      CREATE TABLE Watchlist (
        id INTEGER PRIMARY KEY,
        title TEXT
      )
  ''');
    await db.insert('Watchlist', <String, Object?>{'title': 'Watchlist 1'});
    await db.insert('Watchlist', <String, Object?>{'title': 'Watchlist 2'});

    databaseHelperWatchlist.insertWatchlistMovie(testMovieTable);

    final result = await db.query('Watchlist');
    expect(result, [
      {'id': 1, 'title': 'Watchlist 1'},
      {'id': 2, 'title': 'Watchlist 2'},
    ]);
    await db.close();
  });
}
