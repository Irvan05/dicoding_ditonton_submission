import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:watchlist/domain/usecases/get_watchlist_movies.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies getWatchlistMovies;
  WatchlistMovieBloc({required this.getWatchlistMovies})
      : super(WatchlistMovieLoading()) {
    on<FetchWatchlistMovies>(fetchWatchlistMovies);
  }

  Future<void> fetchWatchlistMovies(
    FetchWatchlistMovies event,
    Emitter<WatchlistMovieState> emit,
  ) async {
    emit(WatchlistMovieLoading());
    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) {
        emit(WatchlistMovieError(error: failure.message));
      },
      (moviesData) {
        emit(WatchlistMovieLoaded(moviesData: moviesData));
      },
    );
  }
}
