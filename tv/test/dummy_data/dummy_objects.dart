import 'package:core/domain/entities/genre.dart';
import 'package:tv/data/models/tv_table.dart';
import 'package:tv/domain/entities/season.dart';
import 'package:tv/domain/entities/season_episode.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';

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

final testTvList = [testTv];

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

final testWatchlistTv = Tv.watchlist(
  id: 66732,
  name: 'Stranger Things',
  posterPath: '/49WJfeN0moxb9IPfGn8AIqMGskD.jpg',
  overview: 'overview',
);

const testTvTable = TvTable(
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
