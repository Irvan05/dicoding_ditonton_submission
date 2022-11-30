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
    backdropPath: '/backdropPath',
    genreIds: const [1],
    id: 557,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 60.441,
    posterPath: 'posterPath',
    releaseDate: '2002-05-01',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];
  const tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: '2002-05-01',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );
  final movieDetailLoadedData = MovieDetailLoadedData(
      movie: tMovieDetail,
      movieRecommendations: tMovieList,
      isRecommendationError: false,
      isAddedToWatchlist: false,
      watchlistMessage: '',
      recommendationError: '');

  group('FetchMovieDetail', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => const Right(tMovieDetail));
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
          data: movieDetailLoadedData,
        ),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
        verify(mockGetWatchListStatusMovie.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Loaded] with recommendation error',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => const Right(tMovieDetail));
        when(mockGetMovieRecommendations.execute(tId)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        when(mockGetWatchListStatusMovie.execute(tId))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(id: tId)),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailLoaded(
          data: movieDetailLoadedData.copyWith(
            movieRecommendations: const <Movie>[],
            isRecommendationError: true,
            recommendationError: 'Server Failure',
          ),
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
        when(mockGetMovieDetail.execute(tId)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(id: tId)),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailError(error: 'Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetMovieDetail.execute(tId));
      },
    );
  });

  group('AddWatchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loaded] after data is saved',
      build: () {
        when(mockSaveWatchlistMovie.execute(tMovieDetail))
            .thenAnswer((_) async => const Right('success'));
        when(mockGetWatchListStatusMovie.execute(tId))
            .thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) async {
        bloc.emit(MovieDetailLoaded(data: movieDetailLoadedData));

        bloc.add(const AddWatchlist(movie: tMovieDetail));
      },
      expect: () => [
        MovieDetailLoaded(data: movieDetailLoadedData),
        MovieDetailLoaded(
          data: movieDetailLoadedData.copyWith(
            isAddedToWatchlist: true,
            watchlistMessage: 'success',
          ),
        ),
      ],
      verify: (bloc) {
        verify(mockGetWatchListStatusMovie.execute(tId));
        verify(mockSaveWatchlistMovie.execute(tMovieDetail));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loaded] and show error when failed',
      build: () {
        when(mockSaveWatchlistMovie.execute(tMovieDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('error')));
        when(mockGetWatchListStatusMovie.execute(tId))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) async {
        bloc.emit(MovieDetailLoaded(data: movieDetailLoadedData));

        bloc.add(const AddWatchlist(movie: tMovieDetail));
      },
      expect: () => [
        MovieDetailLoaded(data: movieDetailLoadedData),
        MovieDetailLoaded(
            data: movieDetailLoadedData.copyWith(
          watchlistMessage: 'error',
        )),
      ],
      verify: (bloc) {
        verify(mockGetWatchListStatusMovie.execute(tId));
        verify(mockSaveWatchlistMovie.execute(tMovieDetail));
      },
    );
  });

  group('RemoveFromWatchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loaded] after data is saved',
      build: () {
        when(mockRemoveWatchlistMovie.execute(tMovieDetail))
            .thenAnswer((_) async => const Right('success'));
        when(mockGetWatchListStatusMovie.execute(tId))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) async {
        bloc.emit(MovieDetailLoaded(
          data: movieDetailLoadedData.copyWith(
            isAddedToWatchlist: true,
          ),
        ));

        bloc.add(const RemoveFromWatchlist(movie: tMovieDetail));
      },
      expect: () => [
        MovieDetailLoaded(
          data: movieDetailLoadedData.copyWith(
            isAddedToWatchlist: true,
          ),
        ),
        MovieDetailLoaded(
            data: movieDetailLoadedData.copyWith(
          watchlistMessage: 'success',
        )),
      ],
      verify: (bloc) {
        verify(mockGetWatchListStatusMovie.execute(tId));
        verify(mockRemoveWatchlistMovie.execute(tMovieDetail));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loaded] and show error when failed',
      build: () {
        when(mockRemoveWatchlistMovie.execute(tMovieDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('error')));
        when(mockGetWatchListStatusMovie.execute(tId))
            .thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) async {
        bloc.emit(MovieDetailLoaded(
          data: movieDetailLoadedData.copyWith(
            isAddedToWatchlist: true,
          ),
        ));

        bloc.add(const RemoveFromWatchlist(movie: tMovieDetail));
      },
      expect: () => [
        MovieDetailLoaded(
          data: movieDetailLoadedData.copyWith(
            isAddedToWatchlist: true,
          ),
        ),
        MovieDetailLoaded(
          data: movieDetailLoadedData.copyWith(
            isAddedToWatchlist: true,
            watchlistMessage: 'error',
          ),
        ),
      ],
      verify: (bloc) {
        verify(mockGetWatchListStatusMovie.execute(tId));
        verify(mockRemoveWatchlistMovie.execute(tMovieDetail));
      },
    );
  });
}
