part of 'watchlist_tv_bloc.dart';

abstract class WatchlistTvState extends Equatable {
  const WatchlistTvState();

  @override
  List<Object> get props => [];
}

class WatchlistTvLoading extends WatchlistTvState {}

class WatchlistTvError extends WatchlistTvState {
  final String error;

  const WatchlistTvError({required this.error});
}

class WatchlistTvLoaded extends WatchlistTvState {
  final List<Tv> tvsData;

  const WatchlistTvLoaded({required this.tvsData});
}

class TvDummyFail extends WatchlistTvState {}
