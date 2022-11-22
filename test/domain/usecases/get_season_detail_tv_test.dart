import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_season_detail_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetSeasonDetailTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetSeasonDetailTv(mockTvRepository);
  });

  final tId = 1;
  final rSeasonNum = 1;

  test('should get season episode from the repository', () async {
    // arrange
    when(mockTvRepository.getSeasonDetailTv(tId, rSeasonNum))
        .thenAnswer((_) async => Right(testSeasonEpisode));
    // act
    final result = await usecase.execute(tId, rSeasonNum);
    // assert
    expect(result, Right(testSeasonEpisode));
  });
}
