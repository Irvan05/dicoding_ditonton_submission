import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:core/utils/failure.dart';

class GetOnTheAirTvs {
  final TvRepository repository;

  GetOnTheAirTvs(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getOnTheAirTvs();
  }
}
