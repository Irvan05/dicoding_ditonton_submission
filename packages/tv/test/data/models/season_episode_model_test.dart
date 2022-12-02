import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/models/season_episode_model.dart';
import 'package:tv/domain/entities/season_episode.dart';

import '../../json_reader.dart';

void main() {
  final tEpisodeResponseModel = EpisodeResponse(
    airDate: DateTime(2016, 7, 15),
    episodeNumber: 1,
    id: 1198665,
    name: "Chapter One: The Vanishing of Will Byers",
    overview: "overview",
    productionCode: "tt6020684",
    runtime: 49,
    seasonNumber: 1,
    showId: 66732,
    stillPath: "/AdwF2jXvhdODr6gUZ61bHKRkz09.jpg",
    voteAverage: 8.47,
    voteCount: 919,
  );
  final tSeasonEpisodeResponseModel = SeasonEpisodeResponse(
      airDate: DateTime(2016, 7, 15),
      episodes: [tEpisodeResponseModel],
      name: "Season 1",
      overview: "overview",
      id: "57599ae2c3a3684ea900242d",
      posterPath: "/rbnuP7hlynAMLdqcQRCpZW9qDkV.jpg",
      seasonNumber: 1,
      seasonDetailId: 77680);

  final tEpisodeModel = Episode(
    airDate: DateTime(2016, 7, 15),
    episodeNumber: 1,
    id: 1198665,
    name: "Chapter One: The Vanishing of Will Byers",
    overview: "overview",
    productionCode: "tt6020684",
    runtime: 49,
    seasonNumber: 1,
    showId: 66732,
    stillPath: "/AdwF2jXvhdODr6gUZ61bHKRkz09.jpg",
    voteAverage: 8.47,
    voteCount: 919,
  );
  final tSeasonEpisodeModel = SeasonEpisode(
      id: "57599ae2c3a3684ea900242d",
      airDate: DateTime(2016, 7, 15),
      episodes: [tEpisodeModel],
      name: "Season 1",
      overview: "overview",
      posterPath: "/rbnuP7hlynAMLdqcQRCpZW9qDkV.jpg",
      seasonNumber: 1,
      seasonDetailId: 77680);
  group('fromJson', () {
    test('should return a valid model from JSON for episode', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/season_episode.json'));
      // act
      final result = EpisodeResponse.fromJson(jsonMap["episodes"][0]);
      // assert
      expect(result, tEpisodeResponseModel);
    });

    test('should return a valid model from JSON for season episode', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/season_episode.json'));
      // act
      final result = SeasonEpisodeResponse.fromJson(jsonMap);
      // assert
      expect(result, tSeasonEpisodeResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data for episode',
        () async {
      // arrange

      // act
      final result = tEpisodeResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "air_date": "2016-07-15",
        "episode_number": 1,
        "id": 1198665,
        "name": "Chapter One: The Vanishing of Will Byers",
        "overview": "overview",
        "production_code": "tt6020684",
        "runtime": 49,
        "season_number": 1,
        "show_id": 66732,
        "still_path": "/AdwF2jXvhdODr6gUZ61bHKRkz09.jpg",
        "vote_average": 8.47,
        "vote_count": 919,
      };
      expect(result, expectedJsonMap);
    });

    test('should return a JSON map containing proper data for season episode',
        () async {
      // arrange

      // act
      final result = tSeasonEpisodeResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "_id": "57599ae2c3a3684ea900242d",
        "air_date": "2016-07-15",
        "episodes": [
          {
            "air_date": "2016-07-15",
            "episode_number": 1,
            "id": 1198665,
            "name": "Chapter One: The Vanishing of Will Byers",
            "overview": "overview",
            "production_code": "tt6020684",
            "runtime": 49,
            "season_number": 1,
            "show_id": 66732,
            "still_path": "/AdwF2jXvhdODr6gUZ61bHKRkz09.jpg",
            "vote_average": 8.47,
            "vote_count": 919,
          }
        ],
        "name": "Season 1",
        "overview": "overview",
        "id": 77680,
        "poster_path": "/rbnuP7hlynAMLdqcQRCpZW9qDkV.jpg",
        "season_number": 1
      };
      expect(result, expectedJsonMap);
    });
  });

  group('toEntity', () {
    test('should be a subclass of Episode entity', () async {
      final result = tEpisodeResponseModel.toEntity();
      expect(result, tEpisodeModel);
    });

    test('should be a subclass of SeasonEpisode entity', () async {
      final result = tSeasonEpisodeResponseModel.toEntity();
      expect(result, tSeasonEpisodeModel);
    });
  });
}
