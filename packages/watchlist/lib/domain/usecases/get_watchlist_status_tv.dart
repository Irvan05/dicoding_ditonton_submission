import 'package:watchlist/domain/repositories/watchlist_repositories.dart';

class GetWatchListStatusTv {
  final WatchlistRepository repository;

  GetWatchListStatusTv(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlistTv(id);
  }
}
