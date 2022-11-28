part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchMovieDetail extends MovieDetailEvent {
  final int id;

  const FetchMovieDetail({required this.id});
}

class AddWatchlist extends MovieDetailEvent {
  final MovieDetail movie;

  const AddWatchlist({required this.movie});
}

class RemoveFromWatchlist extends MovieDetailEvent {
  final MovieDetail movie;

  const RemoveFromWatchlist({required this.movie});
}

// class LoadWatchlistStatus extends MovieDetailEvent {
//   final int id;

//   const LoadWatchlistStatus({required this.id});
// }
