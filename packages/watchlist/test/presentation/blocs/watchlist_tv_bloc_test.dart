import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/tv.dart';
import 'package:watchlist/domain/usecases/get_watchlist_tvs.dart';
import 'package:watchlist/presentation/blocs/watchlist_tv/watchlist_tv_bloc.dart';

import 'watchlist_tv_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvs])
void main() {
  late WatchlistTvBloc watchlistTvBloc;
  late MockGetWatchlistTvs getWatchlistTvs;

  setUp(() {
    getWatchlistTvs = MockGetWatchlistTvs();
    watchlistTvBloc = WatchlistTvBloc(getWatchlistTvs: getWatchlistTvs);
  });

  test('initial state should be loading', () {
    expect(watchlistTvBloc.state, WatchlistTvLoading());
  });

  final tTv = Tv(
      backdropPath: "/56v2KjBlU4XaOv9rVYEQypROD7P.jpg",
      firstAirDate: DateTime(2016, 7, 15), //"2016-07-15",
      genreIds: const [18, 10765, 9648],
      id: 66732,
      name: "Stranger Things",
      originCountry: const ["US"],
      originalLanguage: "en",
      originalName: "Stranger Things",
      overview: "overview",
      popularity: 475.516,
      posterPath: "/49WJfeN0moxb9IPfGn8AIqMGskD.jpg",
      voteAverage: 8.6,
      voteCount: 14335);
  final tTvList = <Tv>[tTv];
  const tFailure = 'error';

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(getWatchlistTvs.execute()).thenAnswer((_) async => Right(tTvList));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvs()),
    expect: () => [
      WatchlistTvLoading(),
      WatchlistTvLoaded(tvsData: tTvList),
    ],
    verify: (bloc) {
      verify(getWatchlistTvs.execute());
    },
  );

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Loading, Error] when failed',
    build: () {
      when(getWatchlistTvs.execute())
          .thenAnswer((_) async => const Left(DatabaseFailure(tFailure)));
      return watchlistTvBloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvs()),
    expect: () => [
      WatchlistTvLoading(),
      const WatchlistTvError(error: tFailure),
    ],
    verify: (bloc) {
      verify(getWatchlistTvs.execute());
    },
  );
}
