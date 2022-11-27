import 'package:core/data/models/genre_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tGenreModel = GenreModel(id: 1, name: 'test');

  group('toJson', () {
    test('should return a JSON map containing proper data for genre model',
        () async {
      // arrange

      // act
      final result = tGenreModel.toJson();
      // assert
      final expectedJsonMap = {"id": 1, "name": 'test'};
      expect(result, expectedJsonMap);
    });
  });
}
