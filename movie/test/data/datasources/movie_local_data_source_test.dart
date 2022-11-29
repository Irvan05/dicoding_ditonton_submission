import 'package:flutter_test/flutter_test.dart';
import 'package:movie/data/datasources/movie_local_data_source.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieLocalDataSourceImpl dataSource;
  late MockDatabaseHelperMovie mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelperMovie();
    dataSource = MovieLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  //TODO:: CACHE TESTING
}
