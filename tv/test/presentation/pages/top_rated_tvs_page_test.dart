import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/presentation/blocs/top_rated_tvs/top_rated_tvs_bloc.dart';
import 'package:tv/presentation/pages/top_rated_tvs_page.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';

class MockTopRatedTvsBloc extends MockBloc<TopRatedTvsEvent, TopRatedTvsState>
    implements TopRatedTvsBloc {}

void main() {
  late TopRatedTvsBloc topRatedTvsBloc;

  setUp(() {
    topRatedTvsBloc = MockTopRatedTvsBloc();
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
    when(() => topRatedTvsBloc.state).thenReturn(TopRatedTvsLoading());

    final progressBarFinder =
        find.byType(CircularProgressIndicator, skipOffstage: false);

    await tester.pumpWidget(_makeTestableWidget(
      TopRatedTvsPage(),
    ));

    expect(topRatedTvsBloc.state, TopRatedTvsLoading());
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('should display error when state are error',
      (WidgetTester tester) async {
    when(() => topRatedTvsBloc.state)
        .thenReturn(const TopRatedTvsError(error: 'error'));

    final widgetFinder = find.byKey(const Key('error_message'));
    await tester.pumpWidget(_makeTestableWidget(
      TopRatedTvsPage(),
    ));

    expect(topRatedTvsBloc.state, const TopRatedTvsError(error: 'error'));
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('should display loaded when state are loaded',
      (WidgetTester tester) async {
    when(() => topRatedTvsBloc.state)
        .thenReturn(TopRatedTvsLoaded(tvs: tTvList));

    final widgetFinder = find.byType(TvCard);
    await tester.pumpWidget(_makeTestableWidget(
      TopRatedTvsPage(),
    ));

    verify(() => topRatedTvsBloc.add(FetchTopRatedTvs())).called(1);
    expect(topRatedTvsBloc.state, TopRatedTvsLoaded(tvs: tTvList));
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('should display unhandled text when state is not found',
      (WidgetTester tester) async {
    when(() => topRatedTvsBloc.state).thenReturn(TopRatedTvsDummy());

    final widgetFinder = find.byKey(const Key('unhandled_message'));
    await tester.pumpWidget(_makeTestableWidget(
      TopRatedTvsPage(),
    ));

    expect(topRatedTvsBloc.state, TopRatedTvsDummy());
    expect(widgetFinder, findsOneWidget);
  });
}
