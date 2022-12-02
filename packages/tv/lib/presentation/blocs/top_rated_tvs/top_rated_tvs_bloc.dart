import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';

part 'top_rated_tvs_event.dart';
part 'top_rated_tvs_state.dart';

class TopRatedTvsBloc extends Bloc<TopRatedTvsEvent, TopRatedTvsState> {
  final GetTopRatedTvs getTopRatedTvs;
  TopRatedTvsBloc({required this.getTopRatedTvs})
      : super(TopRatedTvsLoading()) {
    on<FetchTopRatedTvs>(fetchTopRatedTvs);
  }

  Future<void> fetchTopRatedTvs(
    FetchTopRatedTvs event,
    Emitter<TopRatedTvsState> emit,
  ) async {
    emit(TopRatedTvsLoading());

    final result = await getTopRatedTvs.execute();

    result.fold(
      (failure) {
        emit(TopRatedTvsError(error: failure.message));
      },
      (tvsData) {
        emit(TopRatedTvsLoaded(tvs: tvsData));
      },
    );
  }
}
