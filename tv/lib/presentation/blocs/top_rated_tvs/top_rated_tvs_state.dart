part of 'top_rated_tvs_bloc.dart';

abstract class TopRatedTvsState extends Equatable {
  const TopRatedTvsState();

  @override
  List<Object> get props => [];
}

class TopRatedTvsLoading extends TopRatedTvsState {}

class TopRatedTvsError extends TopRatedTvsState {
  final String error;

  const TopRatedTvsError({required this.error});
}

class TopRatedTvsLoaded extends TopRatedTvsState {
  final List<Tv> tvs;

  const TopRatedTvsLoaded({required this.tvs});
}

class TopRatedTvsDummy extends TopRatedTvsState {}
