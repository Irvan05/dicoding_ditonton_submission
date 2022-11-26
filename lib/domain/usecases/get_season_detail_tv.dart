import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/season_episode.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/common/failure.dart';

class GetSeasonDetailTv {
  final TvRepository repository;

  GetSeasonDetailTv(this.repository);

  Future<Either<Failure, SeasonEpisode>> execute(int id, int seasonNum) {
    return repository.getSeasonDetailTv(id, seasonNum);
  }
}
