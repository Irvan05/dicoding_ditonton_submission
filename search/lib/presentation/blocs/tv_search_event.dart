part of 'tv_search_bloc.dart';

abstract class TvSearchEvent extends Equatable {
  const TvSearchEvent();
}

class OnTvQueryChanged extends TvSearchEvent {
  final String query;

  const OnTvQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}
