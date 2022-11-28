part of 'top_rated_movies_bloc.dart';

abstract class TopRatedMoviesState extends Equatable {
  const TopRatedMoviesState();

  @override
  List<Object> get props => [];
}

class TopRatedMoviesLoading extends TopRatedMoviesState {}

class TopRatedMoviesError extends TopRatedMoviesState {
  final String error;

  TopRatedMoviesError({required this.error});
}

class TopRatedMoviesLoaded extends TopRatedMoviesState {
  final List<Movie> movies;

  TopRatedMoviesLoaded({required this.movies});
}
