import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:movie/data/datasources/db/database_helper_movie.dart';

import '../../dummy_data/dummy_objects.dart';

void sqfliteTestInit() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

Future main() async {
  late DatabaseHelperMovie databaseHelperMovie;

  setUp(() {
    databaseHelperMovie = DatabaseHelperMovie();
  });

  sqfliteTestInit();
  test('insertCacheTransactionMovie', () async {
    var db = await openDatabase(inMemoryDatabasePath);
    await db.execute('''
      CREATE TABLE Movie (
        id INTEGER PRIMARY KEY,
        title TEXT
      )
  ''');
    await db.insert('Movie', <String, Object?>{'title': 'Movie 1'});
    await db.insert('Movie', <String, Object?>{'title': 'Movie 2'});

    when(db.transaction((txn) async => txn.insert(
          'Movie',
          {'title': 'Movie 3'},
        )));

    await databaseHelperMovie.insertCacheTransactionMovie([testMovieTable], 'Movie');

    final result = await db.query('Movie');
    expect(result, [
      {'id': 1, 'title': 'Movie 1'},
      {'id': 2, 'title': 'Movie 2'},
      {'id': 3, 'title': 'Movie 3'}
    ]);
    await db.close();
  });
}
