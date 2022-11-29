import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/search_tvs.dart';
import 'package:search/presentation/blocs/tv_search_bloc.dart';
import 'package:tv/tv.dart';

import 'tv_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTvs])
void main() {
  late TvSearchBloc searchBloc;
  late MockSearchTvs mockSearchTvs;

  setUp(() {
    mockSearchTvs = MockSearchTvs();
    searchBloc = TvSearchBloc(mockSearchTvs);
  });

  test('initial state should be empty', () {
    expect(searchBloc.state, TvSearchEmpty());
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
  const tQuery = 'spiderman';

  blocTest<TvSearchBloc, TvSearchState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTvs.execute(tQuery))
          .thenAnswer((_) async => Right(tTvList));
      return searchBloc;
    },
    act: (bloc) => bloc.add(const OnTvQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSearchLoading(),
      TvSearchHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockSearchTvs.execute(tQuery));
    },
  );

  blocTest<TvSearchBloc, TvSearchState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTvs.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchBloc;
    },
    act: (bloc) => bloc.add(const OnTvQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSearchLoading(),
      const TvSearchError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTvs.execute(tQuery));
    },
  );

  blocTest<TvSearchBloc, TvSearchState>(
    'Should emit [Empty] when search is empty',
    build: () {
      return searchBloc;
    },
    act: (bloc) => bloc.add(const OnTvQueryChanged('')),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSearchEmpty(),
    ],
  );

  blocTest<TvSearchBloc, TvSearchState>(
    'Should emit [Loading, Empty] when result is empty',
    build: () {
      when(mockSearchTvs.execute(tQuery))
          .thenAnswer((_) async => const Right([]));
      return searchBloc;
    },
    act: (bloc) => bloc.add(const OnTvQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSearchLoading(),
      TvSearchEmpty(),
    ],
  );
}
