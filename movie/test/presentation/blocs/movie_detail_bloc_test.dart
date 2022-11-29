import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/presentation/blocs/movie_detail/movie_detail_bloc.dart';
import 'package:watchlist/watchlist.dart';

import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatusMovie,
  SaveWatchlistMovie,
  RemoveWatchlistMovie,
])
void main() {
  late MovieDetailBloc movieDetailBloc;

  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatusMovie mockGetWatchListStatusMovie;
  late MockSaveWatchlistMovie mockSaveWatchlistMovie;
  late MockRemoveWatchlistMovie mockRemoveWatchlistMovie;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatusMovie = MockGetWatchListStatusMovie();
    mockSaveWatchlistMovie = MockSaveWatchlistMovie();
    mockRemoveWatchlistMovie = MockRemoveWatchlistMovie();

    movieDetailBloc = MovieDetailBloc(
        getMovieDetail: mockGetMovieDetail,
        getMovieRecommendations: mockGetMovieRecommendations,
        getWatchListStatus: mockGetWatchListStatusMovie,
        saveWatchlist: mockSaveWatchlistMovie,
        removeWatchlist: mockRemoveWatchlistMovie);
  });

  const tId = 1;

  test('initial state should be loading', () {
    expect(movieDetailBloc.state, MovieDetailLoading());
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
  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  group('FetchMovieDetail', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(tMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovieList));
        when(mockGetWatchListStatusMovie.execute(tId))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(id: tId)),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailLoaded(
          data: MovieDetailLoadedData(
              movie: tMovieDetail,
              movieRecommendations: tMovieList,
              isRecommendationError: false,
              isAddedToWatchlist: false,
              watchlistMessage: '',
              recommendationError: ''),
        ),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
        verify(mockGetWatchListStatusMovie.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Error] when get get is unsuccessful',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovieList));
        // when(_movie).thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(id: tId)),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailError(error: 'Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );
  });
  // blocTest<MovieDetailBloc, MovieDetailState>(
  //   'Should emit [Loading, Loaded] when data is gotten successfully',
  //   build: () {
  //     when(mockGetMovieDetail.execute())
  //         .thenAnswer((_) async => Right(tMovieList));
  //     return movieDetailBloc;
  //   },
  //   act: (bloc) => bloc.add(FetchNowPlayingMovies()),
  //   expect: () => [
  //     MovieDetailLoading(),
  //     MovieDetailLoaded(movies: tMovieList),
  //   ],
  //   verify: (bloc) {
  //     verify(mockGetMovieDetail.execute());
  //   },
  // );

  // blocTest<MovieDetailBloc, MovieDetailState>(
  //   'Should emit [Loading, Error] when get get is unsuccessful',
  //   build: () {
  //     when(mockGetMovieDetail.execute())
  //         .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
  //     return movieDetailBloc;
  //   },
  //   act: (bloc) => bloc.add(FetchNowPlayingMovies()),
  //   wait: const Duration(milliseconds: 500),
  //   expect: () => [
  //     MovieDetailLoading(),
  //     const MovieDetailError(error: 'Server Failure'),
  //   ],
  //   verify: (bloc) {
  //     verify(mockGetMovieDetail.execute());
  //   },
  // );
}
