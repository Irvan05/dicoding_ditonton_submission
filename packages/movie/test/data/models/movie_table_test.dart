import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/data/models/movie_table.dart';
import 'package:movie/domain/entities/movie_detail.dart';

void main() {
  const tMovieTable = MovieTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  const tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
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

  test('should return a MovieTable from entity', () async {
    // arrange

    // act
    final result = MovieTable.fromEntity(tMovieDetail);
    // assert
    expect(result, tMovieTable);
  });
}
