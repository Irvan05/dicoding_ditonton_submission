part of 'popular_tvs_bloc.dart';

abstract class PopularTvsState extends Equatable {
  const PopularTvsState();

  @override
  List<Object> get props => [];
}

class PopularTvsLoading extends PopularTvsState {}

class PopularTvsError extends PopularTvsState {
  final String error;

  const PopularTvsError({required this.error});
}

class PopularTvsLoaded extends PopularTvsState {
  final List<Tv> tvs;

  const PopularTvsLoaded({required this.tvs});
}

class PopularTvsDummy extends PopularTvsState {}
