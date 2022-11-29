part of 'watchlist_movie_bloc.dart';

abstract class WatchlistMovieState extends Equatable {
  const WatchlistMovieState();

  @override
  List<Object> get props => [];
}

class WatchlistMovieLoading extends WatchlistMovieState {}

class WatchlistMovieError extends WatchlistMovieState {
  final String error;

  const WatchlistMovieError({required this.error});
}

class WatchlistMovieLoaded extends WatchlistMovieState {
  final List<Movie> moviesData;

  const WatchlistMovieLoaded({required this.moviesData});
}
