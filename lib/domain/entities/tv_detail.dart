import 'package:core/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:equatable/equatable.dart';

class TvDetail extends Equatable {
  TvDetail({
    required this.adult,
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.firstAirDate,
    required this.seasons,
    required this.status,
    required this.voteAverage,
    required this.voteCount,
  });

  final bool adult;
  final String? backdropPath;
  final List<Genre> genres;
  final int id;
  // final String originalTitle;
  final String name;
  final String overview;
  final String posterPath;
  // final String releaseDate;
  final DateTime firstAirDate;
  // final int runtime;
  final List<Season> seasons;
  // final String title;
  final String status;
  final double voteAverage;
  final int voteCount;

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        genres,
        id,
        name,
        overview,
        posterPath,
        firstAirDate,
        seasons,
        status,
        voteAverage,
        voteCount,
      ];
}
