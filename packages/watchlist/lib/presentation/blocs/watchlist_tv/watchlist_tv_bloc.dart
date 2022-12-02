import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:watchlist/domain/usecases/get_watchlist_tvs.dart';

part 'watchlist_tv_event.dart';
part 'watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTvs getWatchlistTvs;
  WatchlistTvBloc({required this.getWatchlistTvs})
      : super(WatchlistTvLoading()) {
    on<FetchWatchlistTvs>(fetchWatchlistTvs);
  }

  Future<void> fetchWatchlistTvs(
    FetchWatchlistTvs event,
    Emitter<WatchlistTvState> emit,
  ) async {
    emit(WatchlistTvLoading());
    final result = await getWatchlistTvs.execute();
    result.fold(
      (failure) {
        emit(WatchlistTvError(error: failure.message));
      },
      (tvsData) {
        emit(WatchlistTvLoaded(tvsData: tvsData));
      },
    );
  }
}
