import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/season_episode.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);
final testTv = Tv(
    backdropPath: "/56v2KjBlU4XaOv9rVYEQypROD7P.jpg",
    firstAirDate: DateTime(2016, 7, 15), //"2016-07-15",
    genreIds: [18, 10765, 9648],
    id: 66732,
    name: "Stranger Things",
    originCountry: ["US"],
    originalLanguage: "en",
    originalName: "Stranger Things",
    overview: "overview",
    popularity: 475.516,
    posterPath: "/49WJfeN0moxb9IPfGn8AIqMGskD.jpg",
    voteAverage: 8.6,
    voteCount: 14335);

final testMovieList = [testMovie];
final testTvList = [testTv];

final testMovieDetail = MovieDetail(
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
final testTvDetail = TvDetail(
  adult: false,
  backdropPath: "/56v2KjBlU4XaOv9rVYEQypROD7P.jpg",
  genres: [Genre(id: 18, name: 'Drama')],
  id: 66732,
  name: 'Stranger Things',
  overview: "overview",
  posterPath: "/49WJfeN0moxb9IPfGn8AIqMGskD.jpg",
  firstAirDate: DateTime(2017, 7, 15),
  seasons: [
    Season(
        airDate: DateTime(2017, 7, 15),
        episodeCount: 8,
        id: 77680,
        name: "Season 1",
        overview: "overview",
        posterPath: "/rbnuP7hlynAMLdqcQRCpZW9qDkV.jpg",
        seasonNumber: 1)
  ],
  status: "Returning Series",
  voteAverage: 8.641,
  voteCount: 14342,
);

final testEpisode = Episode(
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
final testSeasonEpisode = SeasonEpisode(
  airDate: DateTime(2016, 7, 15),
  episodes: [testEpisode],
  name: "Season 1",
  overview: "overview",
  id: "57599ae2c3a3684ea900242d",
  posterPath: "/rbnuP7hlynAMLdqcQRCpZW9qDkV.jpg",
  seasonNumber: 1,
  seasonDetailId: 77680,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);
final testWatchlistTv = Tv.watchlist(
  id: 66732,
  name: 'Stranger Things',
  posterPath: '/49WJfeN0moxb9IPfGn8AIqMGskD.jpg',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);
final testTvTable = TvTable(
  id: 66732,
  name: 'Stranger Things',
  posterPath: '/49WJfeN0moxb9IPfGn8AIqMGskD.jpg',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};
final testTvMap = {
  'id': 66732,
  'name': 'Stranger Things',
  'posterPath': '/49WJfeN0moxb9IPfGn8AIqMGskD.jpg',
  'overview': 'overview',
};
