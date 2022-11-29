import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'on_the_air_tvs_event.dart';
part 'on_the_air_tvs_state.dart';

class OnTheAirTvsBloc extends Bloc<OnTheAirTvsEvent, OnTheAirTvsState> {
  OnTheAirTvsBloc() : super(OnTheAirTvsInitial()) {
    on<OnTheAirTvsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
