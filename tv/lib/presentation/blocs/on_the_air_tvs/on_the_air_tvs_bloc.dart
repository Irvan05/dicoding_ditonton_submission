import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_on_the_air_tvs.dart';

part 'on_the_air_tvs_event.dart';
part 'on_the_air_tvs_state.dart';

class OnTheAirTvsBloc extends Bloc<OnTheAirTvsEvent, OnTheAirTvsState> {
  final GetOnTheAirTvs getOnTheAirTvs;
  OnTheAirTvsBloc({required this.getOnTheAirTvs})
      : super(OnTheAirTvsLoading()) {
    on<FetchOnTheAirTvs>(fetchOnTheAirTvs);
  }

  Future<void> fetchOnTheAirTvs(
    FetchOnTheAirTvs event,
    Emitter<OnTheAirTvsState> emit,
  ) async {
    emit(OnTheAirTvsLoading());

    final result = await getOnTheAirTvs.execute();

    result.fold(
      (failure) {
        emit(OnTheAirTvsError(error: failure.message));
      },
      (tvsData) {
        emit(OnTheAirTvsLoaded(tvs: tvsData));
      },
    );
  }
}
