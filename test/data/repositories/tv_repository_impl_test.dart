import 'dart:io';

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/data/datasources/tv_local_data_source.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/season_episode_model.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource mockRemoteDataSource;
  late MockTvLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  late MockDatabaseHelper mockDatabaseHelper;
  late TvLocalDataSourceImpl dataSource;

  setUp(() {
    mockRemoteDataSource = MockTvRemoteDataSource();
    mockLocalDataSource = MockTvLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = TvRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );

    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TvLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  final tTvModel = TvModel(
      backdropPath: "/56v2KjBlU4XaOv9rVYEQypROD7P.jpg",
      firstAirDate: DateTime(2016, 7, 15), //"2016-07-15",
      genreIds: [18, 10765, 9648],
      id: 66732,
      name: "Stranger Things",
      originCountry: ["US"],
      originalLanguage: "en",
      originalName: "Stranger Things",
      overview: "overview",
      popularity: 475.516,
      posterPath: "/49WJfeN0moxb9IPfGn8AIqMGskD.jpg",
      voteAverage: 8.6,
      voteCount: 14335);

  final tTv = Tv(
      backdropPath: "/56v2KjBlU4XaOv9rVYEQypROD7P.jpg",
      firstAirDate: DateTime(2016, 7, 15), //"2016-07-15",
      genreIds: [18, 10765, 9648],
      id: 66732,
      name: "Stranger Things",
      originCountry: ["US"],
      originalLanguage: "en",
      originalName: "Stranger Things",
      overview: "overview",
      popularity: 475.516,
      posterPath: "/49WJfeN0moxb9IPfGn8AIqMGskD.jpg",
      voteAverage: 8.6,
      voteCount: 14335);

  final tTvModelList = <TvModel>[tTvModel];
  final tTvList = <Tv>[tTv];

  final testTvCache = TvTable(
    id: 66732,
    overview: 'overview',
    posterPath: '/49WJfeN0moxb9IPfGn8AIqMGskD.jpg',
    name: 'Stranger Things',
  );
  final testTvCacheMap = {
    'id': 66732,
    'overview': 'overview',
    'posterPath': '/49WJfeN0moxb9IPfGn8AIqMGskD.jpg',
    'name': 'Stranger Things',
  };
  final testTvFromCache = Tv(
      backdropPath: null,
      genreIds: null,
      id: 66732,
      name: 'Stranger Things',
      overview: 'overview',
      popularity: null,
      posterPath: "/49WJfeN0moxb9IPfGn8AIqMGskD.jpg",
      originalName: null,
      firstAirDate: null,
      originCountry: null,
      originalLanguage: null,
      voteAverage: null,
      voteCount: null);

  group('on the air Tvs', () {
    test('should check if the device is online', () async {
      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getOnTheAirTvs()).thenAnswer((_) async => []);
      // act
      await repository.getOnTheAirTvs();
      // assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getOnTheAirTvs())
            .thenAnswer((_) async => tTvModelList);
        // act
        final result = await repository.getOnTheAirTvs();
        // assert
        verify(mockRemoteDataSource.getOnTheAirTvs());
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      });

      test(
          'should cache data locally when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getOnTheAirTvs())
            .thenAnswer((_) async => tTvModelList);
        // act
        await repository.getOnTheAirTvs();
        // assert
        verify(mockRemoteDataSource.getOnTheAirTvs());
        verify(mockLocalDataSource.cacheNowPlayingTvs([testTvCache]));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getOnTheAirTvs())
            .thenThrow(ServerException());
        // act
        final result = await repository.getOnTheAirTvs();
        // assert
        verify(mockRemoteDataSource.getOnTheAirTvs());
        expect(result, equals(Left(ServerFailure(''))));
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test('should return cached data when device is offline', () async {
        // arrange
        when(mockLocalDataSource.getCachedNowPlayingTvs())
            .thenAnswer((_) async => [testTvCache]);
        // act
        final result = await repository.getOnTheAirTvs();
        // assert
        verify(mockLocalDataSource.getCachedNowPlayingTvs());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testTvFromCache]);
      });

      test('should return CacheFailure when app has no cache', () async {
        // arrange
        when(mockLocalDataSource.getCachedNowPlayingTvs())
            .thenThrow(CacheException('No Cache'));
        // act
        final result = await repository.getOnTheAirTvs();
        // assert
        verify(mockLocalDataSource.getCachedNowPlayingTvs());
        expect(result, Left(CacheFailure('No Cache')));
      });
    });

    group('cache on the air tvs', () {
      test('should call database helper to save data', () async {
        // arrange
        when(mockDatabaseHelper.clearCacheTv('on the air'))
            .thenAnswer((_) async => 1);
        // act
        await dataSource.cacheNowPlayingTvs([testTvCache]);
        // assert
        verify(mockDatabaseHelper.clearCacheTv('on the air'));
        verify(mockDatabaseHelper
            .insertCacheTransactionTv([testTvCache], 'on the air'));
      });

      test('should return list of tvs from db when data exist', () async {
        // arrange
        when(mockDatabaseHelper.getCacheTvs('on the air'))
            .thenAnswer((_) async => [testTvCacheMap]);
        // act
        final result = await dataSource.getCachedNowPlayingTvs();
        // assert
        expect(result, [testTvCache]);
      });

      test('should throw CacheException when cache data is not exist',
          () async {
        // arrange
        when(mockDatabaseHelper.getCacheTvs('on the air'))
            .thenAnswer((_) async => []);
        // act
        final call = dataSource.getCachedNowPlayingTvs();
        // assert
        expect(() => call, throwsA(isA<CacheException>()));
      });
    });
  });

  group('Popular Tvs', () {
    test('should return tv list when call to data source is success', () async {
      // arrange
      when(mockRemoteDataSource.getPopularTvs())
          .thenAnswer((_) async => tTvModelList);
      // act
      final result = await repository.getPopularTvs();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTvs()).thenThrow(ServerException());
      // act
      final result = await repository.getPopularTvs();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getPopularTvs())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getPopularTvs();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Top Rated Tvs', () {
    test('should return tv list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTvs())
          .thenAnswer((_) async => tTvModelList);
      // act
      final result = await repository.getTopRatedTvs();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTvs()).thenThrow(ServerException());
      // act
      final result = await repository.getTopRatedTvs();
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTopRatedTvs())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTopRatedTvs();
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get Tv Detail', () {
    final tId = 1;
    final tTvResponse = TvDetailResponse(
      adult: false,
      backdropPath: "/56v2KjBlU4XaOv9rVYEQypROD7P.jpg",
      genres: [GenreModel(id: 18, name: 'Drama')],
      id: 66732,
      name: 'Stranger Things',
      overview: "overview",
      posterPath: "/49WJfeN0moxb9IPfGn8AIqMGskD.jpg",
      firstAirDate: DateTime(2017, 7, 15),
      seasons: [
        SeasonModel(
            airDate: DateTime(2017, 7, 15),
            episodeCount: 8,
            id: 77680,
            name: "Season 1",
            overview: "overview",
            posterPath: "/rbnuP7hlynAMLdqcQRCpZW9qDkV.jpg",
            seasonNumber: 1)
      ],
      status: "Returning Series",
      voteAverage: 8.641,
      voteCount: 14342,
      createdBy: null,
      episodeRunTime: null,
      homepage: null,
      inProduction: null,
      languages: null,
      lastAirDate: null,
      lastEpisodeToAir: null,
      nextEpisodeToAir: null,
      networks: null,
      numberOfEpisodes: null,
      numberOfSeasons: null,
      originCountry: null,
      originalLanguage: null,
      originalName: null,
      popularity: null,
      productionCompanies: null,
      productionCountries: null,
      spokenLanguages: null,
      tagline: null,
      type: null,
    );

    test(
        'should return Tv data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvDetail(tId))
          .thenAnswer((_) async => tTvResponse);
      // act
      final result = await repository.getTvDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvDetail(tId));
      expect(result, equals(Right(testTvDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvDetail(tId)).thenThrow(ServerException());
      // act
      final result = await repository.getTvDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvDetail(tId);
      // assert
      verify(mockRemoteDataSource.getTvDetail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Tv Recommendations', () {
    final tTvList = <TvModel>[];
    final tId = 1;

    test('should return data (tv list) when the call is successful', () async {
      // arrange
      when(mockRemoteDataSource.getTvRecommendations(tId))
          .thenAnswer((_) async => tTvList);
      // act
      final result = await repository.getTvRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTvRecommendations(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTvList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvRecommendations(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvRecommendations(tId);
      // assertbuild runner
      verify(mockRemoteDataSource.getTvRecommendations(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getTvRecommendations(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvRecommendations(tId);
      // assert
      verify(mockRemoteDataSource.getTvRecommendations(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Seach Tvs', () {
    final tQuery = 'spiderman';

    test('should return tv list when call to data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvs(tQuery))
          .thenAnswer((_) async => tTvModelList);
      // act
      final result = await repository.searchTvs(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvs(tQuery)).thenThrow(ServerException());
      // act
      final result = await repository.searchTvs(tQuery);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.searchTvs(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.searchTvs(tQuery);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlistTv(testTvTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlistTv(testTvDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
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

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlistTv(testTvTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlistTv(testTvDetail);
      // assert
      expect(result, Right('Removed from watchlist'));
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

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
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

  group('Get Season Episode', () {
    final tId = 1;
    final tSeasonNum = 1;
    final tEpisodeResponse = EpisodeResponse(
      airDate: DateTime(2016, 7, 15),
      episodeNumber: 1,
      id: 1198665,
      name: "Chapter One: The Vanishing of Will Byers",
      overview: "overview",
      productionCode: "tt6020684",
      runtime: 49,
      seasonNumber: 1,
      showId: 66732,
      stillPath: "/AdwF2jXvhdODr6gUZ61bHKRkz09.jpg",
      voteAverage: 8.47,
      voteCount: 919,
    );
    final tSeasonEpisodeResponse = SeasonEpisodeResponse(
      airDate: DateTime(2016, 7, 15),
      episodes: [tEpisodeResponse],
      name: "Season 1",
      overview: "overview",
      id: "57599ae2c3a3684ea900242d",
      posterPath: "/rbnuP7hlynAMLdqcQRCpZW9qDkV.jpg",
      seasonNumber: 1,
      seasonDetailId: 77680,
    );

    test(
        'should return Tv data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeasonDetail(tId, tSeasonNum))
          .thenAnswer((_) async => tSeasonEpisodeResponse);
      // act
      final result = await repository.getSeasonDetailTv(tId, tSeasonNum);
      // assert
      verify(mockRemoteDataSource.getSeasonDetail(tId, tSeasonNum));
      expect(result, equals(Right(testSeasonEpisode)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeasonDetail(tId, tSeasonNum))
          .thenThrow(ServerException());
      // act
      final result = await repository.getSeasonDetailTv(tId, tSeasonNum);
      // assert
      verify(mockRemoteDataSource.getSeasonDetail(tId, tSeasonNum));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getSeasonDetail(tId, tSeasonNum))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getSeasonDetailTv(tId, tSeasonNum);
      // assert
      verify(mockRemoteDataSource.getSeasonDetail(tId, tSeasonNum));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });
}
