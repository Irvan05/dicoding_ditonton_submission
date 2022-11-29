import 'package:watchlist/domain/repositories/watchlist_repositories.dart';

class GetWatchListStatusMovie {
  final WatchlistRepository repository;

  GetWatchListStatusMovie(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlistMovie(id);
  }
}
