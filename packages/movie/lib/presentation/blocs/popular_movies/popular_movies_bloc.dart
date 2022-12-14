import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';

part 'popular_movies_event.dart';
part 'popular_movies_state.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies getPopularMovies;
  PopularMoviesBloc({required this.getPopularMovies})
      : super(PopularMoviesLoading()) {
    on<FetchPopularMovies>(fetchPopularMovies);
  }

  Future<void> fetchPopularMovies(
    FetchPopularMovies event,
    Emitter<PopularMoviesState> emit,
  ) async {
    emit(PopularMoviesLoading());

    final result = await getPopularMovies.execute();

    result.fold(
      (failure) {
        emit(PopularMoviesError(error: failure.message));
      },
      (moviesData) {
        emit(PopularMoviesLoaded(movies: moviesData));
      },
    );
  }
}
