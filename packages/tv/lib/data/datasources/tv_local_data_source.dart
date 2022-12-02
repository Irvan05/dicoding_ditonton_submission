import 'package:core/core.dart';
import 'package:tv/data/datasources/db/database_helper_tv.dart';
import 'package:tv/data/models/tv_table.dart';

abstract class TvLocalDataSource {
  Future<void> cacheNowPlayingTvs(List<TvTable> tvs);
  Future<List<TvTable>> getCachedNowPlayingTvs();
}

class TvLocalDataSourceImpl implements TvLocalDataSource {
  final DatabaseHelperTv databaseHelper;

  TvLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> cacheNowPlayingTvs(List<TvTable> tvs) async {
    await databaseHelper.clearCacheTv('on the air');
    await databaseHelper.insertCacheTransactionTv(tvs, 'on the air');
  }

  @override
  Future<List<TvTable>> getCachedNowPlayingTvs() async {
    final result = await databaseHelper.getCacheTvs('on the air');
    if (result.isNotEmpty) {
      return result.map((data) => TvTable.fromMap(data)).toList();
    } else {
      throw CacheException("Can't get the data :(");
    }
  }
}
