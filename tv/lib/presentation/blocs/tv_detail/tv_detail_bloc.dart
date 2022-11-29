// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/season_episode.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/usecases/get_season_detail_tv.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:watchlist/watchlist.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlistTv saveWatchlist;
  final RemoveWatchlistTv removeWatchlist;
  final GetSeasonDetailTv getSeasonDetailTv;

  TvDetailBloc({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
    required this.getSeasonDetailTv,
  }) : super(TvDetailLoading()) {
    on<FetchTvDetail>(fetchTvDetail);
    on<FetchSeasonEpisodeTv>(fetchSeasonEpisodeTv);
    on<AddWatchlist>(addWatchlist);
    on<RemoveFromWatchlist>(removeFromWatchlist);
  }

  void fetchTvDetail(
    FetchTvDetail event,
    Emitter<TvDetailState> emit,
  ) async {
    final id = event.id;

    emit(TvDetailLoading());

    final detailResult = await getTvDetail.execute(id);
    final recommendationResult = await getTvRecommendations.execute(id);

    late final TvDetail _tv;
    late final List<Tv> _tvs;
    late final bool _isRecommendationError;
    String _recommendationError = '';

    detailResult.fold(
      (failure) {
        emit(TvDetailError(
          error: failure.message,
        ));
        return;
      },
      (tv) {
        _tv = tv;
        recommendationResult.fold(
          (failure) {
            _isRecommendationError = true;
            _recommendationError = failure.message;
          },
          (tvs) {
            _isRecommendationError = false;
            _tvs = tvs;
          },
        );
      },
    );

    final watchlistStatus = await loadWatchlistStatus(_tv.id);
    emit(TvDetailLoaded(
      data: TvDetailLoadedData(
        tv: _tv,
        tvRecommendations: _tvs,
        isRecommendationError: _isRecommendationError,
        recommendationError: _recommendationError,
        seasonEpisodeState: RequestState.Empty,
        seasonEpisode: null,
        isSeasonEpisodeError: false,
        seasonEpisodeError: '',
        isAddedToWatchlist: watchlistStatus,
        watchlistMessage: '',
      ),
    ));
  }

  void fetchSeasonEpisodeTv(
    FetchSeasonEpisodeTv event,
    Emitter<TvDetailState> emit,
  ) async {
    final id = event.id;
    final seasonNum = event.seasonNum;
    final currentState = state;
    if (currentState is TvDetailLoaded) {
      emit(TvDetailLoaded(
        data: currentState.data
            .copyWith(seasonEpisodeState: RequestState.Loading),
      ));
      final detailResult = await getSeasonDetailTv.execute(id, seasonNum);
      detailResult.fold(
        (failure) {
          emit(
            TvDetailLoaded(
                data: currentState.data.copyWith(
              seasonEpisodeState: RequestState.Error,
              seasonEpisodeError: failure.message,
            )),
          );
        },
        (seasonEpisode) {
          emit(
            TvDetailLoaded(
                data: currentState.data.copyWith(
              seasonEpisodeState: RequestState.Loaded,
              seasonEpisode: seasonEpisode,
            )),
          );
        },
      );
    }
  }

  Future<void> addWatchlist(
    AddWatchlist event,
    Emitter<TvDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is TvDetailLoaded) {
      final result = await saveWatchlist.execute(event.tv);
      late final String watchlistMessage;
      result.fold(
        (failure) {
          watchlistMessage = failure.message;
        },
        (successMessage) {
          watchlistMessage = successMessage;
        },
      );

      final watchlistStatus = await loadWatchlistStatus(event.tv.id);
      emit(
        TvDetailLoaded(
          data: currentState.data.copyWith(
            watchlistMessage: watchlistMessage,
            isAddedToWatchlist: watchlistStatus,
          ),
        ),
      );
    }
  }

  Future<void> removeFromWatchlist(
    RemoveFromWatchlist event,
    Emitter<TvDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is TvDetailLoaded) {
      final result = await removeWatchlist.execute(event.tv);
      late final String watchlistMessage;
      result.fold(
        (failure) {
          watchlistMessage = failure.message;
        },
        (successMessage) {
          watchlistMessage = successMessage;
        },
      );

      final watchlistStatus = await loadWatchlistStatus(event.tv.id);
      emit(
        TvDetailLoaded(
          data: currentState.data.copyWith(
            isAddedToWatchlist: watchlistStatus,
            watchlistMessage: watchlistMessage,
          ),
        ),
      );
    }
  }

  Future<bool> loadWatchlistStatus(int id) async {
    return await getWatchListStatus.execute(id);
  }
}
