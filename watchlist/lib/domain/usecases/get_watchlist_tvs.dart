import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv/tv.dart';
import 'package:watchlist/domain/repositories/watchlist_repositories.dart';

class GetWatchlistTvs {
  final WatchlistRepository _repository;

  GetWatchlistTvs(this._repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return _repository.getWatchlistTvs();
  }
}
