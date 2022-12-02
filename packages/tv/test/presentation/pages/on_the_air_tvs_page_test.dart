import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/presentation/blocs/on_the_air_tvs/on_the_air_tvs_bloc.dart';
import 'package:tv/presentation/pages/on_the_air_tvs_page.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';

class MockOnTheAirTvsBloc extends MockBloc<OnTheAirTvsEvent, OnTheAirTvsState>
    implements OnTheAirTvsBloc {}

void main() {
  late OnTheAirTvsBloc topRatedTvsBloc;

  setUp(() {
    topRatedTvsBloc = MockOnTheAirTvsBloc();
  });

  // ignore: no_leading_underscores_for_local_identifiers
  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => topRatedTvsBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final tTv = Tv(
      backdropPath: "/56v2KjBlU4XaOv9rVYEQypROD7P.jpg",
      firstAirDate: DateTime(2016, 7, 15), //"2016-07-15",
      genreIds: const [18, 10765, 9648],
      id: 1,
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

  testWidgets('should display loading when state are loading',
      (WidgetTester tester) async {
    when(() => topRatedTvsBloc.state).thenReturn(OnTheAirTvsLoading());

    final progressBarFinder =
        find.byType(CircularProgressIndicator, skipOffstage: false);

    await tester.pumpWidget(_makeTestableWidget(
      OnTheAirTvsPage(),
    ));

    expect(topRatedTvsBloc.state, OnTheAirTvsLoading());
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('should display error when state are error',
      (WidgetTester tester) async {
    when(() => topRatedTvsBloc.state)
        .thenReturn(const OnTheAirTvsError(error: 'error'));

    final widgetFinder = find.byKey(const Key('error_message'));
    await tester.pumpWidget(_makeTestableWidget(
      OnTheAirTvsPage(),
    ));

    expect(topRatedTvsBloc.state, const OnTheAirTvsError(error: 'error'));
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('should display loaded when state are loaded',
      (WidgetTester tester) async {
    when(() => topRatedTvsBloc.state)
        .thenReturn(OnTheAirTvsLoaded(tvs: tTvList));

    final widgetFinder = find.byType(TvCard);
    await tester.pumpWidget(_makeTestableWidget(
      OnTheAirTvsPage(),
    ));

    verify(() => topRatedTvsBloc.add(FetchOnTheAirTvs())).called(1);
    expect(topRatedTvsBloc.state, OnTheAirTvsLoaded(tvs: tTvList));
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('should display unhandled text when state is not found',
      (WidgetTester tester) async {
    when(() => topRatedTvsBloc.state).thenReturn(OnTheAirTvsDummy());

    final widgetFinder = find.byKey(const Key('unhandled_message'));
    await tester.pumpWidget(_makeTestableWidget(
      OnTheAirTvsPage(),
    ));

    expect(topRatedTvsBloc.state, OnTheAirTvsDummy());
    expect(widgetFinder, findsOneWidget);
  });
}
