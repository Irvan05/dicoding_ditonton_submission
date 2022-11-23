import 'package:ditonton/data/models/tv_table.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvTable = TvTable(
    id: 1,
    name: 'name',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  group('toJson', () {
    test('should return a JSON map containing proper data for tv table',
        () async {
      // arrange

      // act
      final result = tTvTable.toJson();
      // assert
      final expectedJsonMap = {
        "id": 1,
        "name": 'name',
        "posterPath": 'posterPath',
        "overview": 'overview',
      };
      expect(result, expectedJsonMap);
    });
  });
}
