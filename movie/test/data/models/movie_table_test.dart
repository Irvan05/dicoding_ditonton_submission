import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';

void main() {
  final tMovieTable = MovieTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  group('toJson', () {
    test('should return a JSON map containing proper data for movie table',
        () async {
      // arrange

      // act
      final result = tMovieTable.toJson();
      // assert
      final expectedJsonMap = {
        "id": 1,
        "title": 'title',
        "posterPath": 'posterPath',
        "overview": 'overview',
      };
      expect(result, expectedJsonMap);
    });
  });
}
