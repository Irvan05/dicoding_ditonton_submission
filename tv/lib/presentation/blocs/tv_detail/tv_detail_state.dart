part of 'tv_detail_bloc.dart';

class TvDetailLoadedData {
  final TvDetail tv;
  final List<Tv> tvRecommendations;
  final bool isRecommendationError;
  final String recommendationError;
  final RequestState seasonEpisodeState;
  final SeasonEpisode? seasonEpisode;
  final bool isSeasonEpisodeError;
  final String seasonEpisodeError;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  TvDetailLoadedData({
    required this.tv,
    required this.tvRecommendations,
    required this.isRecommendationError,
    required this.recommendationError,
    required this.seasonEpisodeState,
    required this.seasonEpisode,
    required this.seasonEpisodeError,
    required this.isSeasonEpisodeError,
    required this.isAddedToWatchlist,
    required this.watchlistMessage,
  });

  TvDetailLoadedData copyWith({
    TvDetail? tv,
    List<Tv>? tvRecommendations,
    bool? isRecommendationError,
    String? recommendationError,
    RequestState? seasonEpisodeState,
    SeasonEpisode? seasonEpisode,
    bool? isSeasonEpisodeError,
    String? seasonEpisodeError,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
    String? error,
  }) {
    return TvDetailLoadedData(
      tv: tv ?? this.tv,
      tvRecommendations: tvRecommendations ?? this.tvRecommendations,
      isRecommendationError:
          isRecommendationError ?? this.isRecommendationError,
      recommendationError: recommendationError ?? this.recommendationError,
      seasonEpisodeState: seasonEpisodeState ?? this.seasonEpisodeState,
      seasonEpisode: seasonEpisode ?? this.seasonEpisode,
      isSeasonEpisodeError: isSeasonEpisodeError ?? this.isSeasonEpisodeError,
      seasonEpisodeError: seasonEpisodeError ?? this.seasonEpisodeError,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }
}

abstract class TvDetailState extends Equatable {
  @override
  List<Object> get props => [];
}

class TvDetailLoading extends TvDetailState {
  TvDetailLoading();
}

class TvDetailError extends TvDetailState {
  final String error;
  TvDetailError({required this.error});
}

class TvDetailLoaded extends TvDetailState {
  final TvDetailLoadedData data;
  TvDetailLoaded({required this.data});
  @override
  List<Object> get props => [data];
}
