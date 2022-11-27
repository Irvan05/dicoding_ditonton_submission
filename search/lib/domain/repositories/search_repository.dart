import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:movie/movie.dart';
import 'package:tv/tv.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<Movie>>> searchMovies(String query);
  Future<Either<Failure, List<Tv>>> searchTvs(String query);
}
