import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';

void main() {
  final tMovieDetailModel = MovieDetailResponse(
    adult: false,
    backdropPath: 'backdropPath',
    genres: const [GenreModel(id: 1, name: 'test')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
    budget: 1,
    homepage: 'homepage',
    imdbId: 'imdbId',
    originalLanguage: 'originalLanguage',
    popularity: 1,
    revenue: 1,
    status: 'status',
    tagline: 'tagline',
    video: true,
  );

  group('toJson', () {
    test(
        'should return a JSON map containing proper data for movie detail model',
        () async {
      // arrange

      // act
      final result = tMovieDetailModel.toJson();
      // assert
      final expectedJsonMap = {
        "adult": false,
        "backdrop_path": 'backdropPath',
        "genres": [
          {"id": 1, "name": 'test'}
        ],
        "id": 1,
        "original_title": 'originalTitle',
        "overview": 'overview',
        "poster_path": 'posterPath',
        "release_date": 'releaseDate',
        "runtime": 120,
        "title": 'title',
        "vote_average": 1,
        "vote_count": 1,
        "budget": 1,
        "homepage": 'homepage',
        "imdb_id": 'imdbId',
        "original_language": 'originalLanguage',
        "popularity": 1,
        "revenue": 1,
        "status": 'status',
        "tagline": 'tagline',
        "video": true,
      };
      expect(result, expectedJsonMap);
    });
  });
}
