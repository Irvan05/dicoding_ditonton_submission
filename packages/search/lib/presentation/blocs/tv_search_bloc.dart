import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/domain/usecases/search_tvs.dart';
import 'package:tv/tv.dart';
import 'package:rxdart/rxdart.dart';

part 'tv_search_state.dart';
part 'tv_search_event.dart';

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTvs _searchTvs;

  TvSearchBloc(this._searchTvs) : super(TvSearchEmpty()) {
    on<OnTvQueryChanged>(
      (event, emit) async {
        final query = event.query;

        if (query.isEmpty || query == '') {
          emit(TvSearchEmpty());
          return;
        }

        emit(TvSearchLoading());
        final result = await _searchTvs.execute(query);

        result.fold(
          (failure) {
            emit(TvSearchError(failure.message));
          },
          (data) {
            if (data.isEmpty) {
              emit(TvSearchEmpty());
            } else {
              emit(TvSearchHasData(data));
            }
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
