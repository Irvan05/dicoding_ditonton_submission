import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/presentation/blocs/top_rated_tvs/top_rated_tvs_bloc.dart';

import 'top_rated_tvs_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvs])
void main() {
  late TopRatedTvsBloc topRatedTvsBloc;
  late MockGetTopRatedTvs mockGetTopRatedTvs;

  setUp(() {
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    topRatedTvsBloc = TopRatedTvsBloc(getTopRatedTvs: mockGetTopRatedTvs);
  });

  test('initial state should be empty', () {
    expect(topRatedTvsBloc.state, TopRatedTvsLoading());
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

  blocTest<TopRatedTvsBloc, TopRatedTvsState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      return topRatedTvsBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTvs()),
    expect: () => [
      TopRatedTvsLoading(),
      TopRatedTvsLoaded(tvs: tTvList),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTvs.execute());
    },
  );

  blocTest<TopRatedTvsBloc, TopRatedTvsState>(
    'Should emit [Loading, Error] when get is unsuccessful',
    build: () {
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return topRatedTvsBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTvs()),
    expect: () => [
      TopRatedTvsLoading(),
      const TopRatedTvsError(error: 'Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTvs.execute());
    },
  );
}
