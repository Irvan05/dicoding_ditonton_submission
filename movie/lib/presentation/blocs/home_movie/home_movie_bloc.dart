import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';

part 'home_movie_event.dart';
part 'home_movie_state.dart';

class HomeMovieBloc extends Bloc<HomeMovieEvent, HomeMovieState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  HomeMovieBloc({required this.getNowPlayingMovies})
      : super(HomeMovieLoading()) {
    on<FetchNowPlayingMovies>(fetchNowPlayingMovies);
  }

  Future<void> fetchNowPlayingMovies(
    FetchNowPlayingMovies event,
    Emitter<HomeMovieState> emit,
  ) async {
    emit(HomeMovieLoading());

    final result = await getNowPlayingMovies.execute();

    result.fold(
      (failure) {
        emit(HomeMovieError(error: failure.message));
      },
      (moviesData) {
        emit(HomeMovieLoaded(movies: moviesData));
      },
    );
  }
}
