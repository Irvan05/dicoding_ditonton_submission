import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/data/datasources/tv_local_data_source.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvLocalDataSourceImpl dataSource;
  late MockDatabaseHelperTv mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelperTv();
    dataSource = TvLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('cache', () {
    test('getCachedNowPlayingTvs', () async {
      // arrange
      when(
        mockDatabaseHelper.getCacheTvs('on the air'),
      ).thenAnswer((_) async => [testTvMap]);
      // act
      final result = await dataSource.getCachedNowPlayingTvs();
      // assert
      expect(result, [testTvTable]);
    });
    test('insertCacheTransactionTv', () async {
      // arrange
      when(
        mockDatabaseHelper.clearCacheTv('on the air'),
      ).thenAnswer((_) async => 1);
      when(
        mockDatabaseHelper
            .insertCacheTransactionTv([testTvTable], 'on the air'),
      );
      // act
      await dataSource.cacheNowPlayingTvs([testTvTable]);
    });
  });
}
