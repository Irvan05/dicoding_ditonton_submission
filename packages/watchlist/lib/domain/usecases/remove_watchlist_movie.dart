import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:movie/movie.dart';
import 'package:watchlist/domain/repositories/watchlist_repositories.dart';

class RemoveWatchlistMovie {
  final WatchlistRepository repository;

  RemoveWatchlistMovie(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.removeWatchlistMovie(movie);
  }
}
