import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/search_tvs.dart';
import 'package:tv/tv.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTvs usecase;
  late MockSearchRepository mockSearchRepository;

  setUp(() {
    mockSearchRepository = MockSearchRepository();
    usecase = SearchTvs(mockSearchRepository);
  });

  final tTvs = <Tv>[];
  const tQuery = 'Stranger Things';

  test('should get list of tvs from the repository', () async {
    // arrange
    when(mockSearchRepository.searchTvs(tQuery))
        .thenAnswer((_) async => Right(tTvs));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tTvs));
  });
}
