import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';
import 'package:search/domain/usecases/search_movies.dart';
import 'package:search/presentation/blocs/movie_search_bloc.dart';

import 'movie_search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MovieSearchBloc searchBloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    searchBloc = MovieSearchBloc(mockSearchMovies);
  });

  test('initial state should be empty', () {
    expect(searchBloc.state, MovieSearchEmpty());
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovie];
  const tQuery = 'spiderman';

  blocTest<MovieSearchBloc, MovieSearchState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      return searchBloc;
    },
    act: (bloc) => bloc.add(const OnMovieQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      MovieSearchLoading(),
      MovieSearchHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(tQuery));
    },
  );

  blocTest<MovieSearchBloc, MovieSearchState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return searchBloc;
    },
    act: (bloc) => bloc.add(const OnMovieQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      MovieSearchLoading(),
      const MovieSearchError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(tQuery));
    },
  );

  blocTest<MovieSearchBloc, MovieSearchState>(
    'Should emit [Empty] when search is empty',
    build: () {
      return searchBloc;
    },
    act: (bloc) => bloc.add(const OnMovieQueryChanged('')),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      MovieSearchEmpty(),
    ],
  );

  blocTest<MovieSearchBloc, MovieSearchState>(
    'Should emit [Loading, Empty] when result is empty',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => const Right([]));
      return searchBloc;
    },
    act: (bloc) => bloc.add(const OnMovieQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      MovieSearchLoading(),
      MovieSearchEmpty(),
    ],
  );
}
