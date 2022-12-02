import 'package:core/core.dart';
import 'package:http/io_client.dart';
import 'package:mockito/annotations.dart';
import 'package:search/data/datasources/search_remote_data_sources.dart';
import 'package:search/domain/repositories/search_repository.dart';

@GenerateMocks([
  SearchRepository,
  SearchRemoteDataSource,
  NetworkInfo,
  IOClient,
])
void main() {}
