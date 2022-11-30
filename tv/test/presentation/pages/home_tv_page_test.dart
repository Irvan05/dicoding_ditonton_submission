// ignore_for_file: use_key_in_widget_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/presentation/blocs/on_the_air_tvs/on_the_air_tvs_bloc.dart';
import 'package:tv/presentation/blocs/popular_tvs/popular_tvs_bloc.dart';
import 'package:tv/presentation/blocs/top_rated_tvs/top_rated_tvs_bloc.dart';
import 'package:tv/presentation/pages/home_tv_page.dart';

class MockOnTheAirTvsBloc extends MockBloc<OnTheAirTvsEvent, OnTheAirTvsState>
    implements OnTheAirTvsBloc {}

class MockPopularTvsBloc extends MockBloc<PopularTvsEvent, PopularTvsState>
    implements PopularTvsBloc {}

class MockTopRatedTvsBloc extends MockBloc<TopRatedTvsEvent, TopRatedTvsState>
    implements TopRatedTvsBloc {}

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text('Another page')),
    );
  }
}

void main() {
  late OnTheAirTvsBloc onTheAirTvsBloc;
  late PopularTvsBloc popularTvsBloc;
  late TopRatedTvsBloc topRatedTvsBloc;

  setUp(() {
    onTheAirTvsBloc = MockOnTheAirTvsBloc();
    popularTvsBloc = MockPopularTvsBloc();
    topRatedTvsBloc = MockTopRatedTvsBloc();
  });

  // ignore: no_leading_underscores_for_local_identifiers
  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => onTheAirTvsBloc,
        ),
        BlocProvider(
          create: (_) => popularTvsBloc,
        ),
        BlocProvider(
          create: (_) => topRatedTvsBloc,
        ),
      ],
      child: MaterialApp(
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            default:
              return MaterialPageRoute(builder: (_) => TestPage());
          }
        },
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

  testWidgets('should display loading when states are loading',
      (WidgetTester tester) async {
    when(() => onTheAirTvsBloc.state).thenReturn(OnTheAirTvsLoading());
    when(() => popularTvsBloc.state).thenReturn(PopularTvsLoading());
    when(() => topRatedTvsBloc.state).thenReturn(TopRatedTvsLoading());

    final progressBarFinder =
        find.byType(CircularProgressIndicator, skipOffstage: false);

    await tester.pumpWidget(_makeTestableWidget(
      const HomeTvPage(),
    ));

    expect(onTheAirTvsBloc.state, OnTheAirTvsLoading());
    expect(popularTvsBloc.state, PopularTvsLoading());
    expect(topRatedTvsBloc.state, TopRatedTvsLoading());
    expect(progressBarFinder, findsNWidgets(3));
  });

  testWidgets('should display error when states are error',
      (WidgetTester tester) async {
    when(() => onTheAirTvsBloc.state)
        .thenReturn(const OnTheAirTvsError(error: 'error'));
    when(() => popularTvsBloc.state)
        .thenReturn(const PopularTvsError(error: 'error'));
    when(() => topRatedTvsBloc.state)
        .thenReturn(const TopRatedTvsError(error: 'error'));

    final widgetFinder = find.byKey(const Key('on-the-air-error'));
    final widgetFinder2 = find.byKey(const Key('popular-error'));
    final widgetFinder3 = find.byKey(const Key('top-rated-error'));
    await tester.pumpWidget(_makeTestableWidget(
      const HomeTvPage(),
    ));

    verify(() => onTheAirTvsBloc.add(FetchOnTheAirTvs())).called(1);
    expect(onTheAirTvsBloc.state, const OnTheAirTvsError(error: 'error'));
    expect(popularTvsBloc.state, const PopularTvsError(error: 'error'));
    expect(topRatedTvsBloc.state, const TopRatedTvsError(error: 'error'));
    expect(widgetFinder, findsOneWidget);
    expect(widgetFinder2, findsOneWidget);
    expect(widgetFinder3, findsOneWidget);
  });

  testWidgets('should display loaded when states are loaded',
      (WidgetTester tester) async {
    when(() => onTheAirTvsBloc.state)
        .thenReturn(OnTheAirTvsLoaded(tvs: tTvList));
    when(() => popularTvsBloc.state).thenReturn(PopularTvsLoaded(tvs: tTvList));
    when(() => topRatedTvsBloc.state)
        .thenReturn(TopRatedTvsLoaded(tvs: tTvList));

    final widgetFinder = find.byType(TvList);
    await tester.pumpWidget(_makeTestableWidget(
      const HomeTvPage(),
    ));

    expect(
      onTheAirTvsBloc.state,
      OnTheAirTvsLoaded(tvs: tTvList),
    );
    expect(
      popularTvsBloc.state,
      PopularTvsLoaded(tvs: tTvList),
    );
    expect(
      topRatedTvsBloc.state,
      TopRatedTvsLoaded(tvs: tTvList),
    );
    expect(widgetFinder, findsNWidgets(3));
  });

  testWidgets('hould display unhandled text when state is not found',
      (WidgetTester tester) async {
    when(() => onTheAirTvsBloc.state).thenReturn(OnTheAirTvsDummy());
    when(() => popularTvsBloc.state).thenReturn(PopularTvsDummy());
    when(() => topRatedTvsBloc.state).thenReturn(TopRatedTvsDummy());

    final widgetFinder = find.byKey(const Key('on-the-air-unhandled'));
    final widgetFinder2 = find.byKey(const Key('popular-unhandled'));
    final widgetFinder3 = find.byKey(const Key('top-rated-unhandled'));
    await tester.pumpWidget(_makeTestableWidget(
      const HomeTvPage(),
    ));

    expect(onTheAirTvsBloc.state, OnTheAirTvsDummy());
    expect(popularTvsBloc.state, PopularTvsDummy());
    expect(topRatedTvsBloc.state, TopRatedTvsDummy());
    expect(widgetFinder, findsOneWidget);
    expect(widgetFinder2, findsOneWidget);
    expect(widgetFinder3, findsOneWidget);
  });

  testWidgets('test push search', (WidgetTester tester) async {
    when(() => onTheAirTvsBloc.state)
        .thenReturn(OnTheAirTvsLoaded(tvs: tTvList));
    when(() => popularTvsBloc.state).thenReturn(PopularTvsLoaded(tvs: tTvList));
    when(() => topRatedTvsBloc.state)
        .thenReturn(TopRatedTvsLoaded(tvs: tTvList));

    final iconFinder = find.byIcon(Icons.search);

    await tester.pumpWidget(_makeTestableWidget(
      const HomeTvPage(),
    ));
    await tester.tap(iconFinder);
  });

  testWidgets('test push on-the-air-inkwell', (WidgetTester tester) async {
    when(() => onTheAirTvsBloc.state)
        .thenReturn(OnTheAirTvsLoaded(tvs: tTvList));
    when(() => popularTvsBloc.state).thenReturn(PopularTvsLoaded(tvs: tTvList));
    when(() => topRatedTvsBloc.state)
        .thenReturn(TopRatedTvsLoaded(tvs: tTvList));

    final widgetFinder = find.byKey(const Key('On The Air-inkwell'));

    await tester.pumpWidget(_makeTestableWidget(
      const HomeTvPage(),
    ));
    await tester.tap(widgetFinder);
  });

  testWidgets('test push Popular-inkwell', (WidgetTester tester) async {
    when(() => onTheAirTvsBloc.state)
        .thenReturn(OnTheAirTvsLoaded(tvs: tTvList));
    when(() => popularTvsBloc.state).thenReturn(PopularTvsLoaded(tvs: tTvList));
    when(() => topRatedTvsBloc.state)
        .thenReturn(TopRatedTvsLoaded(tvs: tTvList));

    final widgetFinder = find.byKey(const Key('Popular-inkwell'));

    await tester.pumpWidget(_makeTestableWidget(
      const HomeTvPage(),
    ));
    await tester.tap(widgetFinder);
  });

  testWidgets('test push Top Rated-inkwell', (WidgetTester tester) async {
    when(() => onTheAirTvsBloc.state)
        .thenReturn(OnTheAirTvsLoaded(tvs: tTvList));
    when(() => popularTvsBloc.state).thenReturn(PopularTvsLoaded(tvs: tTvList));
    when(() => topRatedTvsBloc.state)
        .thenReturn(TopRatedTvsLoaded(tvs: tTvList));

    final widgetFinder = find.byKey(const Key('Top Rated-inkwell'));

    await tester.pumpWidget(_makeTestableWidget(
      const HomeTvPage(),
    ));
    await tester.tap(widgetFinder);
  });

  testWidgets('test push detail page', (WidgetTester tester) async {
    when(() => onTheAirTvsBloc.state)
        .thenReturn(OnTheAirTvsLoaded(tvs: tTvList));
    when(() => popularTvsBloc.state).thenReturn(PopularTvsLoaded(tvs: tTvList));
    when(() => topRatedTvsBloc.state)
        .thenReturn(TopRatedTvsLoaded(tvs: tTvList));

    final widgetFinder = find.byKey(const Key('on-the-air-0'));

    await tester.pumpWidget(_makeTestableWidget(
      const HomeTvPage(),
    ));
    await tester.tap(widgetFinder);
  });
}
