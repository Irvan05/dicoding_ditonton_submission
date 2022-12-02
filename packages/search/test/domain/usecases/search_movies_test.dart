import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';
import 'package:search/domain/usecases/search_movies.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchMovies usecase;
  late MockSearchRepository mockSearchRepository;

  setUp(() {
    mockSearchRepository = MockSearchRepository();
    usecase = SearchMovies(mockSearchRepository);
  });

  final tMovies = <Movie>[];
  const tQuery = 'Spiderman';

  test('should get list of movies from the repository', () async {
    // arrange
    when(mockSearchRepository.searchMovies(tQuery))
        .thenAnswer((_) async => Right(tMovies));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tMovies));
  });
}
