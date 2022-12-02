part of 'on_the_air_tvs_bloc.dart';

abstract class OnTheAirTvsState extends Equatable {
  const OnTheAirTvsState();

  @override
  List<Object> get props => [];
}

class OnTheAirTvsLoading extends OnTheAirTvsState {}

class OnTheAirTvsError extends OnTheAirTvsState {
  final String error;

  const OnTheAirTvsError({required this.error});
}

class OnTheAirTvsLoaded extends OnTheAirTvsState {
  final List<Tv> tvs;

  const OnTheAirTvsLoaded({required this.tvs});
}

class OnTheAirTvsDummy extends OnTheAirTvsState {}
