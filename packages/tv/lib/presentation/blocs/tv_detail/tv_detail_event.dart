part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTvDetail extends TvDetailEvent {
  final int id;

  const FetchTvDetail({required this.id});
}

class FetchSeasonEpisodeTv extends TvDetailEvent {
  final int id;
  final int seasonNum;

  const FetchSeasonEpisodeTv({required this.id, required this.seasonNum});
}

class AddWatchlist extends TvDetailEvent {
  final TvDetail tv;

  const AddWatchlist({required this.tv});
}

class RemoveFromWatchlist extends TvDetailEvent {
  final TvDetail tv;

  const RemoveFromWatchlist({required this.tv});
}
