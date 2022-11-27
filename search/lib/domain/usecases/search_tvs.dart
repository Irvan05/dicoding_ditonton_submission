import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:search/domain/repositories/search_repository.dart';
import 'package:tv/tv.dart';

class SearchTvs {
  final SearchRepository repository;

  SearchTvs(this.repository);

  Future<Either<Failure, List<Tv>>> execute(String query) {
    return repository.searchTvs(query);
  }
}
