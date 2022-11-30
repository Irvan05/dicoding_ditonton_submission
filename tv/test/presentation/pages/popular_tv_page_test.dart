// ignore_for_file: avoid_print

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/presentation/blocs/popular_tvs/popular_tvs_bloc.dart';
import 'package:tv/presentation/pages/popular_tv_page.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';

class MockPopularTvsBloc extends MockBloc<PopularTvsEvent, PopularTvsState>
    implements PopularTvsBloc {}

// ignore: use_key_in_widget_constructors
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
  late PopularTvsBloc popularTvsBloc;

  setUp(() {
    popularTvsBloc = MockPopularTvsBloc();
  });

  // ignore: no_leading_underscores_for_local_identifiers
  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => popularTvsBloc,
        ),
      ],
      child: MaterialApp(
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            default:
              print(settings.arguments.toString());
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

  testWidgets('should display loading when state are loading',
      (WidgetTester tester) async {
    when(() => popularTvsBloc.state).thenReturn(PopularTvsLoading());

    final progressBarFinder =
        find.byType(CircularProgressIndicator, skipOffstage: false);

    await tester.pumpWidget(_makeTestableWidget(
      PopularTvsPage(),
    ));

    expect(popularTvsBloc.state, PopularTvsLoading());
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('should display error when state are error',
      (WidgetTester tester) async {
    when(() => popularTvsBloc.state)
        .thenReturn(const PopularTvsError(error: 'error'));

    final widgetFinder = find.byKey(const Key('error_message'));
    await tester.pumpWidget(_makeTestableWidget(
      PopularTvsPage(),
    ));

    expect(popularTvsBloc.state, const PopularTvsError(error: 'error'));
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('should display loaded when state are loaded',
      (WidgetTester tester) async {
    when(() => popularTvsBloc.state).thenReturn(PopularTvsLoaded(tvs: tTvList));

    final widgetFinder = find.byType(TvCard);
    await tester.pumpWidget(_makeTestableWidget(
      PopularTvsPage(),
    ));

    verify(() => popularTvsBloc.add(FetchPopularTvs())).called(1);
    expect(popularTvsBloc.state, PopularTvsLoaded(tvs: tTvList));
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('should display unhandled text when state is not found',
      (WidgetTester tester) async {
    when(() => popularTvsBloc.state).thenReturn(PopularTvsDummy());

    final widgetFinder = find.byKey(const Key('unhandled_message'));
    await tester.pumpWidget(_makeTestableWidget(
      PopularTvsPage(),
    ));

    expect(popularTvsBloc.state, PopularTvsDummy());
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('test push search', (WidgetTester tester) async {
    when(() => popularTvsBloc.state).thenReturn(PopularTvsLoaded(tvs: tTvList));

    final widgetFinder = find.byType(InkWell);

    await tester.pumpWidget(_makeTestableWidget(
      PopularTvsPage(),
    ));
    await tester.tap(widgetFinder);
  });
}
