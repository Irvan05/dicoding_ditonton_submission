import 'package:core/core.dart';
import 'package:movie/data/models/movie_table.dart';
import 'db/database_helper_movie.dart';

abstract class MovieLocalDataSource {
  Future<void> cacheNowPlayingMovies(List<MovieTable> movies);
  Future<List<MovieTable>> getCachedNowPlayingMovies();
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final DatabaseHelperMovie databaseHelper;

  MovieLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> cacheNowPlayingMovies(List<MovieTable> movies) async {
    await databaseHelper.clearCacheMovie('now playing');
    await databaseHelper.insertCacheTransactionMovie(movies, 'now playing');
  }

  @override
  Future<List<MovieTable>> getCachedNowPlayingMovies() async {
    final result = await databaseHelper.getCacheMovies('now playing');
    if (result.isNotEmpty) {
      return result.map((data) => MovieTable.fromMap(data)).toList();
    } else {
      throw CacheException("Can't get the data :(");
    }
  }
}
