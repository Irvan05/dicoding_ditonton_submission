import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search/search.dart';

part 'movie_search_state.dart';
part 'movie_search_event.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies _searchMovies;

  MovieSearchBloc(this._searchMovies) : super(MovieSearchEmpty()) {
    on<OnMovieQueryChanged>(
      (event, emit) async {
        final query = event.query;

        emit(MovieSearchLoading());
        final result = await _searchMovies.execute(query);

        result.fold(
          (failure) {
            emit(MovieSearchError(failure.message));
          },
          (data) {
            emit(MovieSearchHasData(data));
          },
        );
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
