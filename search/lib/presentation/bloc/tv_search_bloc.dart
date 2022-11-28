import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/tv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search/search.dart';

part 'tv_search_state.dart';
part 'tv_search_event.dart';

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTvs _searchTvs;

  TvSearchBloc(this._searchTvs) : super(TvSearchEmpty()) {
    on<OnTvQueryChanged>(
      (event, emit) async {
        final query = event.query;

        emit(TvSearchLoading());
        final result = await _searchTvs.execute(query);

        result.fold(
          (failure) {
            emit(TvSearchError(failure.message));
          },
          (data) {
            emit(TvSearchHasData(data));
          },
        );
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
