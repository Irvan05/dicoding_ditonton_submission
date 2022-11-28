part of 'home_movie_bloc.dart';

abstract class HomeMovieState extends Equatable {
  const HomeMovieState();

  @override
  List<Object> get props => [];
}

class HomeMovieLoading extends HomeMovieState {}

class HomeMovieError extends HomeMovieState {
  final String error;

  const HomeMovieError({required this.error});
}

class HomeMovieLoaded extends HomeMovieState {
  final List<Movie> movies;

  const HomeMovieLoaded({required this.movies});
}
