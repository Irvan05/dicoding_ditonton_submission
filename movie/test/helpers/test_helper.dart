import 'package:core/core.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:movie/movie.dart';

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
