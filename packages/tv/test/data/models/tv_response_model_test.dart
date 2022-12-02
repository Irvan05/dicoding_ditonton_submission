import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/models/tv_model.dart';
import 'package:tv/data/models/tv_response.dart';

import '../../json_reader.dart';

void main() {
  final tTvModel = TvModel(
      backdropPath: "/path.jpg",
      genreIds: const [80, 10765],
      id: 90462,
      name: 'name',
      overview: 'overview',
      popularity: 3642.719,
      posterPath: "/path.jpg",
      originalName: 'original_name',
      firstAirDate: DateTime(2021, 10, 12),
      originCountry: const ['US'],
      originalLanguage: 'en',
      voteAverage: 7.9,
      voteCount: 3481);
  final tTvResponseModel = TvResponse(tvList: <TvModel>[tTvModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_on_the_air.json'));
      // act
      final result = TvResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/path.jpg",
            "first_air_date": "2021-10-12",
            "genre_ids": [80, 10765],
            "id": 90462,
            "name": "name",
            "origin_country": ["US"],
            "original_language": "en",
            "original_name": "original_name",
            "overview": "overview",
            "popularity": 3642.719,
            "poster_path": "/path.jpg",
            "vote_average": 7.9,
            "vote_count": 3481
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
