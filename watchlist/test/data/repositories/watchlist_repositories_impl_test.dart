import 'dart:io';

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';
import 'package:watchlist/watchlist.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late WatchlistRepositoryImpl repository;
  late MockWatchlistLocalDataSource mockLocalDataSource;
  // late MockDatabaseHelperWatchlist mockDatabaseHelper;

  // late WatchlistLocalDataSourceImpl dataSource;

  setUp(() {
    mockLocalDataSource = MockWatchlistLocalDataSource();
    repository = WatchlistRepositoryImpl(
      localDataSource: mockLocalDataSource,
    );

    // mockDatabaseHelper = MockDatabaseHelperWatchlist();
    // dataSource =
    //     WatchlistLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  // final tMovieModel = MovieModel(
  //   adult: false,
  //   backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  //   genreIds: const [14, 28],
  //   id: 557,
  //   originalTitle: 'Spider-Man',
  //   overview:
  //       'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  //   popularity: 60.441,
  //   posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  //   releaseDate: '2002-05-01',
  //   title: 'Spider-Man',
  //   video: false,
  //   voteAverage: 7.2,
  //   voteCount: 13507,
  // );

  // final tMovie = Movie(
  //   adult: false,
  //   backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  //   genreIds: const [14, 28],
  //   id: 557,
  //   originalTitle: 'Spider-Man',
  //   overview:
  //       'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  //   popularity: 60.441,
  //   posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  //   releaseDate: '2002-05-01',
  //   title: 'Spider-Man',
  //   video: false,
  //   voteAverage: 7.2,
  //   voteCount: 13507,
  // );

  // final tMovieModelList = <MovieModel>[tMovieModel];
  // final tMovieList = <Movie>[tMovie];

  // final testMovieCache = MovieTable(
  //   id: 557,
  //   overview:
  //       'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  //   posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  //   title: 'Spider-Man',
  // );
  // final testMovieCacheMap = {
  //   'id': 557,
  //   'overview':
  //       'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  //   'posterPath': '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  //   'title': 'Spider-Man',
  // };
  // final testMovieFromCache = Movie(
  //   adult: null,
  //   backdropPath: null,
  //   genreIds: null,
  //   id: 557,
  //   originalTitle: null,
  //   overview:
  //       'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  //   popularity: null,
  //   posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  //   releaseDate: null,
  //   title: 'Spider-Man',
  //   video: null,
  //   voteAverage: null,
  //   voteCount: null,
  // );

  group('save watchlist movie', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlistMovie(testMovieTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlistMovie(testMovieDetail);
      // assert
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlistMovie(testMovieTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlistMovie(testMovieDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist movie', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlistMovie(testMovieTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlistMovie(testMovieDetail);
      // assert
      expect(result, const Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlistMovie(testMovieTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlistMovie(testMovieDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status movie', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getMovieById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlistMovie(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist movies', () {
    test('should return list of Movies', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistMovies())
          .thenAnswer((_) async => [testMovieTable]);
      // act
      final result = await repository.getWatchlistMovies();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistMovie]);
    });
  });

  group('save watchlist tv', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlistTv(testTvTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlistTv(testTvDetail);
      // assert
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlistTv(testTvTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlistTv(testTvDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist tv', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlistTv(testTvTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlistTv(testTvDetail);
      // assert
      expect(result, const Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlistTv(testTvTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlistTv(testTvDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status tv', () {
    test('should return watch status whether data is found', () async {
      // arrange
      const tId = 1;
      when(mockLocalDataSource.getTvById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlistTv(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist tvs', () {
    test('should return list of Tvs', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistTvs())
          .thenAnswer((_) async => [testTvTable]);
      // act
      final result = await repository.getWatchlistTvs();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTv]);
    });
  });
}
