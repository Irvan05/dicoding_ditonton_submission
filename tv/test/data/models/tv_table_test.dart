import 'package:core/domain/entities/genre.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/tv.dart';

void main() {
  const tTvTable = TvTable(
    id: 1,
    name: 'name',
    posterPath: 'posterPath',
    overview: 'overview',
  );
  final tTvDetail = TvDetail(
    adult: false,
    backdropPath: "posterPath",
    genres: [Genre(id: 18, name: 'Drama')],
    id: 1,
    name: 'name',
    overview: "overview",
    posterPath: "posterPath",
    firstAirDate: DateTime(2017, 7, 15),
    seasons: [
      Season(
          airDate: DateTime(2017, 7, 15),
          episodeCount: 8,
          id: 77680,
          name: "Season 1",
          overview: "overview",
          posterPath: "posterPath",
          seasonNumber: 1)
    ],
    status: "Returning Series",
    voteAverage: 8.641,
    voteCount: 14342,
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

  test('should return a TvTable from entity', () async {
    // arrange

    // act
    final result = TvTable.fromEntity(tTvDetail);
    // assert
    expect(result, tTvTable);
  });
}
