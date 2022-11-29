import 'package:watchlist/domain/repositories/watchlist_repositories.dart';

class GetWatchListStatus {
  final WatchlistRepository repository;

  GetWatchListStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlistTv(id);
  }
}
