import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv/domain/entities/season_episode.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

class GetSeasonDetailTv {
  final TvRepository repository;

  GetSeasonDetailTv(this.repository);

  Future<Either<Failure, SeasonEpisode>> execute(int id, int seasonNum) {
    return repository.getSeasonDetailTv(id, seasonNum);
  }
}
