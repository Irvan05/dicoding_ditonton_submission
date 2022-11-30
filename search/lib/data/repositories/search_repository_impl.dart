import 'dart:io';

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:movie/movie.dart';
import 'package:search/data/datasources/search_remote_data_sources.dart';
import 'package:search/domain/repositories/search_repository.dart';
import 'package:tv/tv.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async {
    try {
      final result = await remoteDataSource.searchMovies(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> searchTvs(String query) async {
    try {
      final result = await remoteDataSource.searchTvs(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}
