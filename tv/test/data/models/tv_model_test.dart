import 'package:flutter_test/flutter_test.dart';
import 'package:tv/data/models/tv_model.dart';
import 'package:tv/domain/entities/tv.dart';

void main() {
  final tTvModel = TvModel(
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    name: 'name',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    originalName: 'originalName',
    firstAirDate: DateTime(2020, 1, 1),
    originCountry: const ['en'],
    originalLanguage: 'en',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTv = Tv(
      backdropPath: 'backdropPath',
      genreIds: const [1, 2, 3],
      id: 1,
      name: 'name',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      originalName: 'originalName',
      firstAirDate: DateTime(2020, 1, 1),
      originCountry: const ['en'],
      originalLanguage: 'en',
      voteAverage: 1,
      voteCount: 1);

  test('should be a subclass of Tv entity', () async {
    final result = tTvModel.toEntity();
    expect(result, tTv);
  });
}
