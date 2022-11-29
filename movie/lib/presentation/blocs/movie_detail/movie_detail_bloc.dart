// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:watchlist/watchlist.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatusMovie getWatchListStatus;
  final SaveWatchlistMovie saveWatchlist;
  final RemoveWatchlistMovie removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieDetailLoading()) {
    on<FetchMovieDetail>(fetchMovieDetail);
    on<AddWatchlist>(addWatchlist);
    on<RemoveFromWatchlist>(removeFromWatchlist);
  }

  void fetchMovieDetail(
    FetchMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    final id = event.id;

    emit(MovieDetailLoading());

    final detailResult = await getMovieDetail.execute(id);
    final recommendationResult = await getMovieRecommendations.execute(id);

    late final MovieDetail _movie;
    late final List<Movie> _movies;
    late final bool _isRecommendationError;
    String _recommendationError = '';

    detailResult.fold(
      (failure) {
        emit(MovieDetailError(
          error: failure.message,
        ));
        return;
      },
      (movie) {
        _movie = movie;
        recommendationResult.fold(
          (failure) {
            _isRecommendationError = true;
            _recommendationError = failure.message;
          },
          (movies) {
            _isRecommendationError = false;
            _movies = movies;
          },
        );
      },
    );

    final watchlistStatus = await loadWatchlistStatus(_movie.id);
    emit(MovieDetailLoaded(
      data: MovieDetailLoadedData(
        movie: _movie,
        movieRecommendations: _movies,
        isRecommendationError: _isRecommendationError,
        isAddedToWatchlist: watchlistStatus,
        watchlistMessage: '',
        recommendationError: _recommendationError,
      ),
    ));
  }

  Future<void> addWatchlist(
    AddWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is MovieDetailLoaded) {
      final result = await saveWatchlist.execute(event.movie);
      late final String watchlistMessage;
      result.fold(
        (failure) {
          watchlistMessage = failure.message;
        },
        (successMessage) {
          watchlistMessage = successMessage;
        },
      );

      final watchlistStatus = await loadWatchlistStatus(event.movie.id);
      emit(
        MovieDetailLoaded(
          data: currentState.data.copyWith(
            watchlistMessage: watchlistMessage,
            isAddedToWatchlist: watchlistStatus,
          ),
        ),
      );
    }
  }

  Future<void> removeFromWatchlist(
    RemoveFromWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is MovieDetailLoaded) {
      final result = await removeWatchlist.execute(event.movie);
      late final String watchlistMessage;
      result.fold(
        (failure) {
          watchlistMessage = failure.message;
        },
        (successMessage) {
          watchlistMessage = successMessage;
        },
      );

      final watchlistStatus = await loadWatchlistStatus(event.movie.id);
      emit(
        MovieDetailLoaded(
          data: currentState.data.copyWith(
            isAddedToWatchlist: watchlistStatus,
            watchlistMessage: watchlistMessage,
          ),
        ),
      );
    }
  }

  Future<bool> loadWatchlistStatus(int id) async {
    return await getWatchListStatus.execute(id);
  }
}
