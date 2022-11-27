import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv/tv.dart';
import 'package:watchlist/domain/repositories/watchlist_repositories.dart';

class SaveWatchlistTv {
  final WatchlistRepository repository;

  SaveWatchlistTv(this.repository);

  Future<Either<Failure, String>> execute(TvDetail tv) {
    return repository.saveWatchlistTv(tv);
  }
}
