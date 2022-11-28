import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_movie_event.dart';
part 'home_movie_state.dart';

class HomeMovieBloc extends Bloc<HomeMovieEvent, HomeMovieState> {
  HomeMovieBloc() : super(HomeMovieInitial()) {
    on<HomeMovieEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
