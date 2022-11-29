part of 'movie_search_bloc.dart';

abstract class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();
}

class OnMovieQueryChanged extends MovieSearchEvent {
  final String query;

  const OnMovieQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}
