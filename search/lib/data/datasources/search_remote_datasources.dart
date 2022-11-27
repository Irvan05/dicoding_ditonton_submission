import 'dart:convert';

import 'package:core/core.dart';
import 'package:movie/movie.dart';
import 'package:tv/tv.dart';

import 'package:http/http.dart' as http;

abstract class SearchRemoteDatasources {
  Future<List<MovieModel>> searchMovies(String query);
  Future<List<TvModel>> searchTvs(String query);
}

class SearchRemoteDatasourceImpls implements SearchRemoteDatasources {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final http.Client client;

  SearchRemoteDatasourceImpls({required this.client});

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/search/movie?$API_KEY&query=$query'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> searchTvs(String query) async {
    final response = await client
        .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$query'));

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }
}
