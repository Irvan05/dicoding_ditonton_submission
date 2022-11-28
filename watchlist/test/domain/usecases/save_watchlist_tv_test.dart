import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/watchlist.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistTv usecase;
  late MockWatchlistRepository mockWatchlistRepository;

  setUp(() {
    mockWatchlistRepository = MockWatchlistRepository();
    usecase = SaveWatchlistTv(mockWatchlistRepository);
  });

  test('should save tv to the repository', () async {
    // arrange
    when(mockWatchlistRepository.saveWatchlistTv(testTvDetail))
        .thenAnswer((_) async => const Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTvDetail);
    // assert
    verify(mockWatchlistRepository.saveWatchlistTv(testTvDetail));
    expect(result, const Right('Added to Watchlist'));
  });
}
