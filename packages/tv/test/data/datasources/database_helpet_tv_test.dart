import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tv/data/datasources/db/database_helper_tv.dart';

import '../../dummy_data/dummy_objects.dart';

void sqfliteTestInit() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

Future main() async {
  late DatabaseHelperTv databaseHelperTv;

  setUp(() {
    databaseHelperTv = DatabaseHelperTv();
  });

  sqfliteTestInit();
  test('insertCacheTransactionTv', () async {
    var db = await openDatabase(inMemoryDatabasePath);
    await db.execute('''
      CREATE TABLE Tv (
        id INTEGER PRIMARY KEY,
        title TEXT
      )
  ''');
    await db.insert('Tv', <String, Object?>{'title': 'Tv 1'});
    await db.insert('Tv', <String, Object?>{'title': 'Tv 2'});

    when(db.transaction((txn) async => txn.insert(
          'Tv',
          {'title': 'Tv 3'},
        )));

    await databaseHelperTv.insertCacheTransactionTv([testTvTable], 'Tv');

    final result = await db.query('Tv');
    expect(result, [
      {'id': 1, 'title': 'Tv 1'},
      {'id': 2, 'title': 'Tv 2'},
      {'id': 3, 'title': 'Tv 3'}
    ]);
    await db.close();
  });
}
