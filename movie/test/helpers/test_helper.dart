import 'package:core/core.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:movie/data/datasources/db/database_helper_movie.dart';
import 'package:movie/data/datasources/movie_local_data_source.dart';
import 'package:movie/data/datasources/movie_remote_data_source.dart';
import 'package:movie/domain/repositories/movie_repository.dart';

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  DatabaseHelperMovie,
  NetworkInfo,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient),
])
void main() {}
