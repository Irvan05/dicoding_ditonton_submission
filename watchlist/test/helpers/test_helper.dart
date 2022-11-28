import 'package:core/core.dart';
import 'package:mockito/annotations.dart';
import 'package:watchlist/watchlist.dart';

@GenerateMocks(
  [
    WatchlistRepository,
    WatchlistLocalDataSource,
    DatabaseHelperWatchlist,
    NetworkInfo,
  ],
)
void main() {}
