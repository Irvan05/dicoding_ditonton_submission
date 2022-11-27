import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:tv/domain/entities/season_episode.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';

abstract class TvRepository {
  Future<Either<Failure, List<Tv>>> getOnTheAirTvs();
  Future<Either<Failure, List<Tv>>> getPopularTvs();
  Future<Either<Failure, List<Tv>>> getTopRatedTvs();
  Future<Either<Failure, TvDetail>> getTvDetail(int id);
  Future<Either<Failure, List<Tv>>> getTvRecommendations(int id);
  // Future<Either<Failure, List<Tv>>> searchTvs(String query);
  // Future<Either<Failure, String>> saveWatchlistTv(TvDetail movie);
  // Future<Either<Failure, String>> removeWatchlistTv(TvDetail movie);
  // Future<bool> isAddedToWatchlistTv(int id);
  // Future<Either<Failure, List<Tv>>> getWatchlistTvs();
  Future<Either<Failure, SeasonEpisode>> getSeasonDetailTv(
      int id, int seasonNum);
}
