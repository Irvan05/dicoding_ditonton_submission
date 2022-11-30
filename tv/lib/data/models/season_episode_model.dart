// ignore_for_file: prefer_if_null_operators, prefer_null_aware_operators

import 'package:tv/domain/entities/season_episode.dart';
import 'package:equatable/equatable.dart';

class SeasonEpisodeResponse extends Equatable {
  const SeasonEpisodeResponse({
    required this.id,
    required this.airDate,
    required this.episodes,
    required this.name,
    required this.overview,
    required this.seasonDetailId,
    required this.posterPath,
    required this.seasonNumber,
  });

  final String? id;
  final DateTime? airDate;
  final List<EpisodeResponse>? episodes;
  final String? name;
  final String? overview;
  final int? seasonDetailId;
  final String? posterPath;
  final int? seasonNumber;

  factory SeasonEpisodeResponse.fromJson(Map<String, dynamic> json) =>
      SeasonEpisodeResponse(
        id: json["_id"] == null ? null : json["_id"],
        airDate:
            json["air_date"] == null ? null : DateTime.parse(json["air_date"]),
        episodes: json["episodes"] == null
            ? null
            : List<EpisodeResponse>.from(
                json["episodes"].map((x) => EpisodeResponse.fromJson(x))),
        name: json["name"] == null ? null : json["name"],
        overview: json["overview"] == null ? null : json["overview"],
        seasonDetailId: json["id"] == null ? null : json["id"],
        posterPath: json["poster_path"] == null ? null : json["poster_path"],
        seasonNumber:
            json["season_number"] == null ? null : json["season_number"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "air_date": airDate == null
            ? null
            : "${airDate!.year.toString().padLeft(4, '0')}-${airDate!.month.toString().padLeft(2, '0')}-${airDate!.day.toString().padLeft(2, '0')}",
        "episodes": episodes == null
            ? null
            : List<dynamic>.from(episodes!.map((x) => x.toJson())),
        "name": name == null ? null : name,
        "overview": overview == null ? null : overview,
        "id": seasonDetailId == null ? null : seasonDetailId,
        "poster_path": posterPath == null ? null : posterPath,
        "season_number": seasonNumber == null ? null : seasonNumber,
      };

  SeasonEpisode toEntity() {
    return SeasonEpisode(
        id: id,
        airDate: airDate,
        episodes: episodes == null
            ? null
            : episodes!.map((e) => e.toEntity()).toList(),
        name: name,
        overview: overview,
        seasonDetailId: seasonDetailId,
        posterPath: posterPath,
        seasonNumber: seasonNumber);
  }

  @override
  List<Object?> get props => [
        id,
        airDate,
        episodes,
        name,
        overview,
        seasonDetailId,
        posterPath,
        seasonNumber
      ];
}

class EpisodeResponse extends Equatable {
  const EpisodeResponse({
    required this.airDate,
    required this.episodeNumber,
    required this.id,
    required this.name,
    required this.overview,
    required this.productionCode,
    required this.runtime,
    required this.seasonNumber,
    required this.showId,
    required this.stillPath,
    required this.voteAverage,
    required this.voteCount,
  });

  final DateTime? airDate;
  final int? episodeNumber;
  final int? id;
  final String? name;
  final String? overview;
  final String? productionCode;
  final int? runtime;
  final int? seasonNumber;
  final int? showId;
  final String? stillPath;
  final double? voteAverage;
  final int? voteCount;

  factory EpisodeResponse.fromJson(Map<String, dynamic> json) =>
      EpisodeResponse(
        airDate:
            json["air_date"] == null ? null : DateTime.parse(json["air_date"]),
        episodeNumber:
            json["episode_number"] == null ? null : json["episode_number"],
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        overview: json["overview"] == null ? null : json["overview"],
        productionCode:
            json["production_code"] == null ? null : json["production_code"],
        runtime: json["runtime"] == null ? null : json["runtime"],
        seasonNumber:
            json["season_number"] == null ? null : json["season_number"],
        showId: json["show_id"] == null ? null : json["show_id"],
        stillPath: json["still_path"] == null ? null : json["still_path"],
        voteAverage: json["vote_average"] == null
            ? null
            : json["vote_average"].toDouble(),
        voteCount: json["vote_count"] == null ? null : json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "air_date": airDate == null
            ? null
            : "${airDate!.year.toString().padLeft(4, '0')}-${airDate!.month.toString().padLeft(2, '0')}-${airDate!.day.toString().padLeft(2, '0')}",
        "episode_number": episodeNumber == null ? null : episodeNumber,
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "overview": overview == null ? null : overview,
        "production_code": productionCode == null ? null : productionCode,
        "runtime": runtime == null ? null : runtime,
        "season_number": seasonNumber == null ? null : seasonNumber,
        "show_id": showId == null ? null : showId,
        "still_path": stillPath == null ? null : stillPath,
        "vote_average": voteAverage == null ? null : voteAverage,
        "vote_count": voteCount == null ? null : voteCount,
      };

  Episode toEntity() {
    return Episode(
        airDate: airDate,
        episodeNumber: episodeNumber,
        id: id,
        name: name,
        overview: overview,
        productionCode: productionCode,
        runtime: runtime,
        seasonNumber: seasonNumber,
        showId: showId,
        stillPath: stillPath,
        voteAverage: voteAverage,
        voteCount: voteCount);
  }

  @override
  List<Object?> get props => [
        airDate,
        episodeNumber,
        id,
        name,
        overview,
        productionCode,
        runtime,
        seasonNumber,
        showId,
        stillPath,
        voteAverage,
        voteCount
      ];
}
