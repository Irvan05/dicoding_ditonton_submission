import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:movie/movie.dart';
import 'package:tv/tv.dart';

abstract class WatchlistRepository {
  //movie
  Future<Either<Failure, String>> saveWatchlistMovie(MovieDetail movie);
  Future<Either<Failure, String>> removeWatchlistMovie(MovieDetail movie);
  Future<bool> isAddedToWatchlistMovie(int id);
  Future<Either<Failure, List<Movie>>> getWatchlistMovies();
  //tv
  Future<Either<Failure, String>> saveWatchlistTv(TvDetail movie);
  Future<Either<Failure, String>> removeWatchlistTv(TvDetail movie);
  Future<bool> isAddedToWatchlistTv(int id);
  Future<Either<Failure, List<Tv>>> getWatchlistTvs();
}
