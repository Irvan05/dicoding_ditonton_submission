import 'package:core/domain/entities/genre.dart';
import 'package:tv/domain/entities/season.dart';
import 'package:equatable/equatable.dart';

class TvDetail extends Equatable {
  const TvDetail({
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
  final String name;
  final String overview;
  final String posterPath;
  final DateTime firstAirDate;
  final List<Season> seasons;
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
