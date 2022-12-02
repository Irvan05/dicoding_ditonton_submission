import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';

part 'popular_tvs_event.dart';
part 'popular_tvs_state.dart';

class PopularTvsBloc extends Bloc<PopularTvsEvent, PopularTvsState> {
  final GetPopularTvs getPopularTvs;
  PopularTvsBloc({required this.getPopularTvs}) : super(PopularTvsLoading()) {
    on<FetchPopularTvs>(fetchPopularTvs);
  }

  Future<void> fetchPopularTvs(
    FetchPopularTvs event,
    Emitter<PopularTvsState> emit,
  ) async {
    emit(PopularTvsLoading());

    final result = await getPopularTvs.execute();

    result.fold(
      (failure) {
        emit(PopularTvsError(error: failure.message));
      },
      (tvsData) {
        emit(PopularTvsLoaded(tvs: tvsData));
      },
    );
  }
}
