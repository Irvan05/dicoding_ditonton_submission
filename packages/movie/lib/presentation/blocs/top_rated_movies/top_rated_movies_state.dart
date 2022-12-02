part of 'top_rated_movies_bloc.dart';

abstract class TopRatedMoviesState extends Equatable {
  const TopRatedMoviesState();

  @override
  List<Object> get props => [];
}

class TopRatedMoviesLoading extends TopRatedMoviesState {}

class TopRatedMoviesError extends TopRatedMoviesState {
  final String error;

  const TopRatedMoviesError({required this.error});
}

class TopRatedMoviesLoaded extends TopRatedMoviesState {
  final List<Movie> movies;

  const TopRatedMoviesLoaded({required this.movies});
}

class TopRatedMoviesDummy extends TopRatedMoviesState {}
