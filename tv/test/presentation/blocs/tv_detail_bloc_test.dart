import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/season.dart';
import 'package:tv/domain/entities/season_episode.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/usecases/get_season_detail_tv.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/presentation/blocs/tv_detail/tv_detail_bloc.dart';
import 'package:watchlist/domain/usecases/get_watchlist_status_tv.dart';
import 'package:watchlist/domain/usecases/remove_watchlist_tv.dart';
import 'package:watchlist/domain/usecases/save_watchlist_tv.dart';

import 'tv_detail_bloc_test.mocks.dart';

// import 'tv_detail_bloc_test.mocks.dart';
//
@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetSeasonDetailTv,
  GetWatchListStatusTv,
  SaveWatchlistTv,
  RemoveWatchlistTv,
])
void main() {
  late TvDetailBloc tvDetailBloc;

  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchListStatusTv mockGetWatchListStatusTv;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;
  late MockGetSeasonDetailTv mockGetSeasonDetailTv;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchListStatusTv = MockGetWatchListStatusTv();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    mockGetSeasonDetailTv = MockGetSeasonDetailTv();

    tvDetailBloc = TvDetailBloc(
        getTvDetail: mockGetTvDetail,
        getTvRecommendations: mockGetTvRecommendations,
        getWatchListStatusTv: mockGetWatchListStatusTv,
        saveWatchlistTv: mockSaveWatchlistTv,
        removeWatchlistTv: mockRemoveWatchlistTv,
        getSeasonDetailTv: mockGetSeasonDetailTv);
  });

  test('initial state should be loading', () {
    expect(tvDetailBloc.state, TvDetailLoading());
  });

  final tTv = Tv(
      backdropPath: "/56v2KjBlU4XaOv9rVYEQypROD7P.jpg",
      firstAirDate: DateTime(2016, 7, 15), //"2016-07-15",
      genreIds: const [18, 10765, 9648],
      id: 1,
      name: "Stranger Things",
      originCountry: const ["US"],
      originalLanguage: "en",
      originalName: "Stranger Things",
      overview: "overview",
      popularity: 475.516,
      posterPath: "/49WJfeN0moxb9IPfGn8AIqMGskD.jpg",
      voteAverage: 8.6,
      voteCount: 14335);
  final tTvList = <Tv>[tTv];
  final tTvDetail = TvDetail(
    adult: false,
    backdropPath: "/56v2KjBlU4XaOv9rVYEQypROD7P.jpg",
    genres: [Genre(id: 1, name: 'Drama')],
    id: 1,
    name: 'Stranger Things',
    overview: "overview",
    posterPath: "/49WJfeN0moxb9IPfGn8AIqMGskD.jpg",
    firstAirDate: DateTime(2017, 7, 15),
    seasons: [
      Season(
          airDate: DateTime(2017, 7, 15),
          episodeCount: 8,
          id: 1,
          name: "Season 1",
          overview: "overview",
          posterPath: "/rbnuP7hlynAMLdqcQRCpZW9qDkV.jpg",
          seasonNumber: 1)
    ],
    status: "Returning Series",
    voteAverage: 1,
    voteCount: 1,
  );
  final tvDetailLoadedData = TvDetailLoadedData(
    tv: tTvDetail,
    tvRecommendations: tTvList,
    isRecommendationError: false,
    recommendationError: '',
    seasonEpisodeState: RequestState.Empty,
    seasonEpisode: null,
    seasonEpisodeError: '',
    isAddedToWatchlist: false,
    watchlistMessage: '',
  );

  final tEpisode = Episode(
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
  final tSeasonEpisode = SeasonEpisode(
    airDate: DateTime(2016, 7, 15),
    episodes: [tEpisode],
    name: "Season 1",
    overview: "overview",
    id: "57599ae2c3a3684ea900242d",
    posterPath: "/rbnuP7hlynAMLdqcQRCpZW9qDkV.jpg",
    seasonNumber: 1,
    seasonDetailId: 77680,
  );

  const tId = 1;
  const tSeasonNum = 1;

  group('FetchTvDetail', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Right(tTvDetail));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvList));
        when(mockGetWatchListStatusTv.execute(tId))
            .thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(id: tId)),
      expect: () => [
        TvDetailLoading(),
        TvDetailLoaded(
          data: tvDetailLoadedData,
        ),
      ],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendations.execute(tId));
        verify(mockGetWatchListStatusTv.execute(tId));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [Loading, Loaded] with recommendation error',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Right(tTvDetail));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetWatchListStatusTv.execute(tId))
            .thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(id: tId)),
      expect: () => [
        TvDetailLoading(),
        TvDetailLoaded(
          data: tvDetailLoadedData.copyWith(
            tvRecommendations: const <Tv>[],
            isRecommendationError: true,
            recommendationError: 'Server Failure',
          ),
        ),
      ],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendations.execute(tId));
        verify(mockGetWatchListStatusTv.execute(tId));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [Loading, Error] when get get is unsuccessful',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(id: tId)),
      expect: () => [
        TvDetailLoading(),
        TvDetailError(error: 'Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTvDetail.execute(tId));
      },
    );
  });

  group('FetchSeasonEpisodeTv', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [Loaded] after data is get',
      build: () {
        when(mockGetSeasonDetailTv.execute(tId, tSeasonNum))
            .thenAnswer((_) async => Right(tSeasonEpisode));
        return tvDetailBloc;
      },
      act: (bloc) {
        bloc.emit(TvDetailLoaded(data: tvDetailLoadedData));
        bloc.add(
          const FetchSeasonEpisodeTv(id: tId, seasonNum: tSeasonNum),
        );
      },
      expect: () => [
        TvDetailLoaded(data: tvDetailLoadedData),
        TvDetailLoaded(
          data: tvDetailLoadedData.copyWith(
              seasonEpisodeState: RequestState.Loading),
        ),
        TvDetailLoaded(
            data: tvDetailLoadedData.copyWith(
          seasonEpisodeState: RequestState.Loaded,
          seasonEpisode: tSeasonEpisode,
        ))
      ],
      verify: (bloc) {
        verify(mockGetSeasonDetailTv.execute(tId, tSeasonNum));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [Loaded] with failed state if get is unsucessful',
      build: () {
        when(mockGetSeasonDetailTv.execute(tId, tSeasonNum))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return tvDetailBloc;
      },
      act: (bloc) {
        bloc.emit(TvDetailLoaded(data: tvDetailLoadedData));
        bloc.add(const FetchSeasonEpisodeTv(id: tId, seasonNum: tSeasonNum));
      },
      expect: () => [
        TvDetailLoaded(data: tvDetailLoadedData),
        TvDetailLoaded(
          data: tvDetailLoadedData.copyWith(
              seasonEpisodeState: RequestState.Loading),
        ),
        TvDetailLoaded(
            data: tvDetailLoadedData.copyWith(
          seasonEpisodeState: RequestState.Error,
          seasonEpisodeError: 'Server Failure',
        )),
      ],
      verify: (bloc) {
        verify(mockGetSeasonDetailTv.execute(tId, tSeasonNum));
      },
    );
  });

  group('AddWatchlist', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [Loaded] after data is saved',
      build: () {
        when(mockSaveWatchlistTv.execute(tTvDetail))
            .thenAnswer((_) async => const Right('success'));
        when(mockGetWatchListStatusTv.execute(tId))
            .thenAnswer((_) async => true);
        return tvDetailBloc;
      },
      act: (bloc) async {
        bloc.emit(TvDetailLoaded(data: tvDetailLoadedData));
        bloc.add(AddWatchlist(tv: tTvDetail));
      },
      expect: () => [
        TvDetailLoaded(data: tvDetailLoadedData),
        TvDetailLoaded(
          data: tvDetailLoadedData.copyWith(
            isAddedToWatchlist: true,
            watchlistMessage: 'success',
          ),
        ),
      ],
      verify: (bloc) {
        verify(mockGetWatchListStatusTv.execute(tId));
        verify(mockSaveWatchlistTv.execute(tTvDetail));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [Loaded] and show error when failed',
      build: () {
        when(mockSaveWatchlistTv.execute(tTvDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('error')));
        when(mockGetWatchListStatusTv.execute(tId))
            .thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) async {
        bloc.emit(TvDetailLoaded(data: tvDetailLoadedData));

        bloc.add(AddWatchlist(tv: tTvDetail));
      },
      expect: () => [
        TvDetailLoaded(data: tvDetailLoadedData),
        TvDetailLoaded(
            data: tvDetailLoadedData.copyWith(
          watchlistMessage: 'error',
        )),
      ],
      verify: (bloc) {
        verify(mockGetWatchListStatusTv.execute(tId));
        verify(mockSaveWatchlistTv.execute(tTvDetail));
      },
    );
  });

  group('RemoveFromWatchlist', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [Loaded] after data is saved',
      build: () {
        when(mockRemoveWatchlistTv.execute(tTvDetail))
            .thenAnswer((_) async => const Right('success'));
        when(mockGetWatchListStatusTv.execute(tId))
            .thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) async {
        bloc.emit(TvDetailLoaded(
          data: tvDetailLoadedData.copyWith(
            isAddedToWatchlist: true,
          ),
        ));

        bloc.add(RemoveFromWatchlist(tv: tTvDetail));
      },
      expect: () => [
        TvDetailLoaded(
          data: tvDetailLoadedData.copyWith(
            isAddedToWatchlist: true,
          ),
        ),
        TvDetailLoaded(
            data: tvDetailLoadedData.copyWith(
          watchlistMessage: 'success',
        )),
      ],
      verify: (bloc) {
        verify(mockGetWatchListStatusTv.execute(tId));
        verify(mockRemoveWatchlistTv.execute(tTvDetail));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit [Loaded] and show error when failed',
      build: () {
        when(mockRemoveWatchlistTv.execute(tTvDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('error')));
        when(mockGetWatchListStatusTv.execute(tId))
            .thenAnswer((_) async => true);
        return tvDetailBloc;
      },
      act: (bloc) async {
        bloc.emit(TvDetailLoaded(
          data: tvDetailLoadedData.copyWith(
            isAddedToWatchlist: true,
          ),
        ));

        bloc.add(RemoveFromWatchlist(tv: tTvDetail));
      },
      expect: () => [
        TvDetailLoaded(
          data: tvDetailLoadedData.copyWith(
            isAddedToWatchlist: true,
          ),
        ),
        TvDetailLoaded(
          data: tvDetailLoadedData.copyWith(
            isAddedToWatchlist: true,
            watchlistMessage: 'error',
          ),
        ),
      ],
      verify: (bloc) {
        verify(mockGetWatchListStatusTv.execute(tId));
        verify(mockRemoveWatchlistTv.execute(tTvDetail));
      },
    );
  });
}
