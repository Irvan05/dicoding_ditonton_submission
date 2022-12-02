// ignore_for_file: must_be_immutable

part of 'movie_detail_bloc.dart';

class MovieDetailLoadedData extends Equatable {
  final MovieDetail movie;
  final List<Movie> movieRecommendations;
  final bool isRecommendationError;
  final bool isAddedToWatchlist;
  final String watchlistMessage;
  final String recommendationError;

  const MovieDetailLoadedData({
    required this.movie,
    required this.movieRecommendations,
    required this.isRecommendationError,
    required this.isAddedToWatchlist,
    required this.watchlistMessage,
    required this.recommendationError,
  });

  MovieDetailLoadedData copyWith({
    MovieDetail? movie,
    List<Movie>? movieRecommendations,
    bool? isRecommendationError,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
    String? recommendationError,
  }) {
    return MovieDetailLoadedData(
      movie: movie ?? this.movie,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      isRecommendationError:
          isRecommendationError ?? this.isRecommendationError,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      recommendationError: recommendationError ?? this.recommendationError,
    );
  }

  @override
  List<Object> get props => [
        movie,
        movieRecommendations,
        isRecommendationError,
        isAddedToWatchlist,
        watchlistMessage,
        recommendationError
      ];
}

abstract class MovieDetailState extends Equatable {
  @override
  List<Object> get props => [];
}

class MovieDetailLoading extends MovieDetailState {
  MovieDetailLoading();
}

class MovieDetailError extends MovieDetailState {
  final String error;
  MovieDetailError({required this.error});
}

class MovieDetailLoaded extends MovieDetailState {
  final MovieDetailLoadedData data;
  MovieDetailLoaded({required this.data});
  @override
  List<Object> get props => [data];
}

class MovieDetailDummy extends MovieDetailState {}
