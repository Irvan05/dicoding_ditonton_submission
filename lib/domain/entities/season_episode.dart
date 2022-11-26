// To parse this JSON data, do
//
//     final seasonDetail = seasonDetailFromJson(jsonString);

import 'package:equatable/equatable.dart';

class SeasonEpisode extends Equatable {
  SeasonEpisode({
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
  final List<Episode>? episodes;
  final String? name;
  final String? overview;
  final int? seasonDetailId;
  final String? posterPath;
  final int? seasonNumber;

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

class Episode extends Equatable {
  Episode({
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
