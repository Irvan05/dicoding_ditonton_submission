import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_on_the_air_tvs.dart';
import 'package:tv/presentation/blocs/on_the_air_tvs/on_the_air_tvs_bloc.dart';

import 'on_the_air_tvs_bloc_test.mocks.dart';

@GenerateMocks([GetOnTheAirTvs])
void main() {
  late OnTheAirTvsBloc homeTvBloc;
  late MockGetOnTheAirTvs mockGetOnTheAirTvs;

  setUp(() {
    mockGetOnTheAirTvs = MockGetOnTheAirTvs();
    homeTvBloc = OnTheAirTvsBloc(getOnTheAirTvs: mockGetOnTheAirTvs);
  });

  test('initial state should be loading', () {
    expect(homeTvBloc.state, OnTheAirTvsLoading());
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

  blocTest<OnTheAirTvsBloc, OnTheAirTvsState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      return homeTvBloc;
    },
    act: (bloc) => bloc.add(FetchOnTheAirTvs()),
    expect: () => [
      OnTheAirTvsLoading(),
      OnTheAirTvsLoaded(tvs: tTvList),
    ],
    verify: (bloc) {
      verify(mockGetOnTheAirTvs.execute());
    },
  );

  blocTest<OnTheAirTvsBloc, OnTheAirTvsState>(
    'Should emit [Loading, Error] when get get is unsuccessful',
    build: () {
      when(mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return homeTvBloc;
    },
    act: (bloc) => bloc.add(FetchOnTheAirTvs()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      OnTheAirTvsLoading(),
      const OnTheAirTvsError(error: 'Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetOnTheAirTvs.execute());
    },
  );
}
