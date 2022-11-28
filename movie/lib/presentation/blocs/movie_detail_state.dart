// ignore_for_file: must_be_immutable

part of 'movie_detail_bloc.dart';

class MovieDetailLoadedData {
  final MovieDetail movie;
  final List<Movie> movieRecommendations;
  final bool isRecommentaionError;
  final bool isAddedToWatchlist;
  final String watchlistMessage;
  final String recommentaionError;

  MovieDetailLoadedData({
    required this.movie,
    required this.movieRecommendations,
    required this.isRecommentaionError,
    required this.isAddedToWatchlist,
    required this.watchlistMessage,
    required this.recommentaionError,
  });

  MovieDetailLoadedData copyWith({
    MovieDetail? movie,
    List<Movie>? movieRecommendations,
    bool? isRecommentaionError,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
    String? error,
    String? recommendationError,
  }) {
    return MovieDetailLoadedData(
      movie: movie ?? this.movie,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      isRecommentaionError: isRecommentaionError ?? this.isRecommentaionError,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      recommentaionError: recommendationError ?? this.recommentaionError,
    );
  }
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
