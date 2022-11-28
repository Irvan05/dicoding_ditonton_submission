import 'package:core/core.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:search/search.dart';

@GenerateMocks([
  SearchRepository,
  SearchRemoteDataSource,
  NetworkInfo,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient),
])
void main() {}
