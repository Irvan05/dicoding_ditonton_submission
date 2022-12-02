import 'package:dartz/dartz.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:core/core.dart';
import 'package:watchlist/domain/repositories/watchlist_repositories.dart';

class GetWatchlistMovies {
  final WatchlistRepository _repository;

  GetWatchlistMovies(this._repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return _repository.getWatchlistMovies();
  }
}
