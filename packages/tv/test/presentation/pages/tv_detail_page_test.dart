// ignore_for_file: avoid_print

import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/domain/entities/season.dart';
import 'package:tv/domain/entities/season_episode.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/presentation/blocs/tv_detail/tv_detail_bloc.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvDetailBloc extends MockBloc<TvDetailEvent, TvDetailState>
    implements TvDetailBloc {}

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
  late TvDetailBloc tvDetailBloc;

  setUp(() {
    tvDetailBloc = MockTvDetailBloc();
  });

  // ignore: no_leading_underscores_for_local_identifiers
  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => tvDetailBloc,
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
  final tTvDetail = TvDetail(
    adult: false,
    backdropPath: "/56v2KjBlU4XaOv9rVYEQypROD7P.jpg",
    genres: const [Genre(id: 18, name: 'Drama')],
    id: 66732,
    name: 'Stranger Things',
    overview: "overview",
    posterPath: "/49WJfeN0moxb9IPfGn8AIqMGskD.jpg",
    firstAirDate: DateTime(2017, 7, 15),
    seasons: [
      Season(
          airDate: DateTime(2017, 7, 15),
          episodeCount: 8,
          id: 1,
          name: "Season 1",
          overview: "overview",
          posterPath: "posterPath",
          seasonNumber: 1)
    ],
    status: "Returning Series",
    voteAverage: 8.641,
    voteCount: 14342,
  );
  final tvDetailLoadedData = TvDetailLoadedData(
    tv: tTvDetail,
    tvRecommendations: tTvList,
    isRecommendationError: false,
    recommendationError: '',
    seasonEpisodeState: RequestState.Empty,
    seasonEpisode: null,
    seasonEpisodeError: '',
    isAddedToWatchlist: false,
    watchlistMessage: '',
  );
  final tSeasonEpisode = SeasonEpisode(
    airDate: DateTime(2016, 7, 15),
    episodes: [testEpisode],
    name: "Season 1",
    overview: "overview overview overview overview overview overview",
    id: "57599ae2c3a3684ea900242d",
    posterPath: "/rbnuP7hlynAMLdqcQRCpZW9qDkV.jpg",
    seasonNumber: 1,
    seasonDetailId: 77680,
  );
  const tId = 1;

  testWidgets('should display loading when state are loading',
      (WidgetTester tester) async {
    when(() => tvDetailBloc.state).thenReturn(TvDetailLoading());

    final progressBarFinder =
        find.byType(CircularProgressIndicator, skipOffstage: false);

    await tester.pumpWidget(_makeTestableWidget(
      const TvDetailPage(id: tId),
    ));

    expect(tvDetailBloc.state, TvDetailLoading());
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('should display error when state are error',
      (WidgetTester tester) async {
    when(() => tvDetailBloc.state).thenReturn(TvDetailError(error: 'error'));

    final widgetFinder = find.byKey(const Key('detail-error'));
    await tester.pumpWidget(_makeTestableWidget(
      const TvDetailPage(id: tId),
    ));

    expect(tvDetailBloc.state, TvDetailError(error: 'error'));
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('should display unhandled text when state is not found',
      (WidgetTester tester) async {
    when(() => tvDetailBloc.state).thenReturn(TvDetailDummy());

    final widgetFinder = find.byKey(const Key('unhandler-error'));
    await tester.pumpWidget(_makeTestableWidget(
      const TvDetailPage(id: tId),
    ));

    expect(tvDetailBloc.state, TvDetailDummy());
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('should display loaded and recommendation when state are loaded',
      (WidgetTester tester) async {
    when(() => tvDetailBloc.state)
        .thenReturn(TvDetailLoaded(data: tvDetailLoadedData));

    final widgetFinder = find.byType(DetailContent);
    final listviewFinder = find.byType(ListView, skipOffstage: false);
    final backFinder = find.byIcon(Icons.arrow_back);
    await tester.pumpWidget(_makeTestableWidget(
      const TvDetailPage(id: tId),
    ));

    expect(
      tvDetailBloc.state,
      TvDetailLoaded(data: tvDetailLoadedData),
    );
    expect(widgetFinder, findsOneWidget);
    expect(listviewFinder, findsAtLeastNWidgets(2));
    expect(backFinder, findsOneWidget);
  });

  testWidgets(
      'should display recommnendation error when state are loaded and recommendation is error',
      (WidgetTester tester) async {
    when(() => tvDetailBloc.state).thenReturn(TvDetailLoaded(
        data: tvDetailLoadedData.copyWith(isRecommendationError: true)));

    final widgetFinder = find.byType(DetailContent);
    final keyFinder =
        find.byKey(const Key('recommendation-error-text'), skipOffstage: false);
    await tester.pumpWidget(_makeTestableWidget(
      const TvDetailPage(id: tId),
    ));

    expect(
      tvDetailBloc.state,
      TvDetailLoaded(
          data: tvDetailLoadedData.copyWith(isRecommendationError: true)),
    );
    expect(widgetFinder, findsOneWidget);
    expect(keyFinder, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    final expectedStates = [
      TvDetailLoaded(
          data: tvDetailLoadedData.copyWith(
              watchlistMessage: 'Added to Watchlist'))
    ];

    whenListen(
      tvDetailBloc,
      Stream.fromIterable(expectedStates),
      initialState: TvDetailLoading(),
    );

    await tester.pumpWidget(_makeTestableWidget(
      const TvDetailPage(id: tId),
    ));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    final expectedStates = [
      TvDetailLoaded(
          data: tvDetailLoadedData.copyWith(watchlistMessage: 'Failed'))
    ];

    whenListen(
      tvDetailBloc,
      Stream.fromIterable(expectedStates),
      initialState: TvDetailLoading(),
    );

    await tester.pumpWidget(_makeTestableWidget(
      const TvDetailPage(id: tId),
    ));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('add to watchlist event', (WidgetTester tester) async {
    when(() => tvDetailBloc.state)
        .thenReturn(TvDetailLoaded(data: tvDetailLoadedData));

    final buttonFinder = find.byIcon(Icons.add).first;

    await tester.pumpWidget(_makeTestableWidget(
      const TvDetailPage(id: tId),
    ));
    await tester.tap(buttonFinder);
    await tester.pump();

    verify(() => tvDetailBloc.add(AddWatchlist(tv: tTvDetail))).called(1);
  });

  testWidgets('remove to watchlist event', (WidgetTester tester) async {
    when(() => tvDetailBloc.state).thenReturn(TvDetailLoaded(
        data: tvDetailLoadedData.copyWith(isAddedToWatchlist: true)));

    final buttonFinder = find.byIcon(Icons.check).first;

    await tester.pumpWidget(_makeTestableWidget(
      const TvDetailPage(id: tId),
    ));
    await tester.tap(buttonFinder);
    await tester.pump();

    verify(() => tvDetailBloc.add(RemoveFromWatchlist(tv: tTvDetail)))
        .called(1);
  });

  testWidgets('test open tv detail', (WidgetTester tester) async {
    when(() => tvDetailBloc.state)
        .thenReturn(TvDetailLoaded(data: tvDetailLoadedData));

    final scrollFinder = find.byType(Scrollable);
    final widgetFinder = find
        .byKey(const Key('recommendation-inkwell-0'), skipOffstage: false)
        .first;

    await tester.pumpWidget(_makeTestableWidget(
      const TvDetailPage(id: tId),
    ));
    await tester.scrollUntilVisible(
      widgetFinder,
      500.0,
      scrollable: scrollFinder.first,
    );
    await tester.tap(widgetFinder);
  });

  testWidgets('test pop tv detail', (WidgetTester tester) async {
    when(() => tvDetailBloc.state)
        .thenReturn(TvDetailLoaded(data: tvDetailLoadedData));

    final widgetFinder = find.byIcon(Icons.arrow_back).first;

    await tester.pumpWidget(_makeTestableWidget(
      const TvDetailPage(id: tId),
    ));
    await tester.tap(widgetFinder);
  });

  testWidgets('Should display season episode loading',
      (WidgetTester tester) async {
    when(() => tvDetailBloc.state).thenReturn(TvDetailLoaded(
        data: tvDetailLoadedData.copyWith(
      seasonEpisodeState: RequestState.Loading,
    )));

    final scrollFinder = find.byType(Scrollable);
    final widgetFinder2 = find.byKey(const Key('ListView-SeasonList'));
    final inkWellSeason =
        find.byKey(const Key('FetchSeasonEpisodeTv-inkwel-0'));

    await tester.pumpWidget(_makeTestableWidget(
      const TvDetailPage(id: tId),
    ));
    await tester.scrollUntilVisible(
      inkWellSeason,
      500.0,
      scrollable: scrollFinder.first,
    );
    expect(widgetFinder2, findsOneWidget);
    expect(inkWellSeason, findsOneWidget);

    await tester.tap(inkWellSeason);
    await tester.pump();

    expect(
      find.byType(TvSeasonBottomSheet, skipOffstage: false),
      findsOneWidget,
    );
    expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
  });

  group('TvSeasonBottomSheet', () {
    testWidgets('Should display season episode error',
        (WidgetTester tester) async {
      when(() => tvDetailBloc.state).thenReturn(TvDetailLoaded(
          data: tvDetailLoadedData.copyWith(
        seasonEpisodeState: RequestState.Error,
        seasonEpisodeError: 'error',
      )));

      final scrollFinder = find.byType(Scrollable);
      final widgetFinder2 = find.byKey(const Key('ListView-SeasonList'));
      final inkWellSeason =
          find.byKey(const Key('FetchSeasonEpisodeTv-inkwel-0'));

      await tester.pumpWidget(_makeTestableWidget(
        const TvDetailPage(id: tId),
      ));
      await tester.scrollUntilVisible(
        inkWellSeason,
        500.0,
        scrollable: scrollFinder.first,
      );
      expect(widgetFinder2, findsOneWidget);
      expect(inkWellSeason, findsOneWidget);

      await tester.tap(inkWellSeason);
      await tester.pump();

      expect(
        find.byType(TvSeasonBottomSheet, skipOffstage: false),
        findsOneWidget,
      );
      expect(find.byKey(const Key('season-sheet-error')), findsOneWidget);
    });

    testWidgets('Should display season episode unhandled',
        (WidgetTester tester) async {
      when(() => tvDetailBloc.state).thenReturn(TvDetailLoaded(
          data: tvDetailLoadedData.copyWith(
        seasonEpisodeState: RequestState.Empty,
      )));

      final scrollFinder = find.byType(Scrollable);
      final widgetFinder2 = find.byKey(const Key('ListView-SeasonList'));
      final inkWellSeason =
          find.byKey(const Key('FetchSeasonEpisodeTv-inkwel-0'));

      await tester.pumpWidget(_makeTestableWidget(
        const TvDetailPage(id: tId),
      ));
      await tester.scrollUntilVisible(
        inkWellSeason,
        500.0,
        scrollable: scrollFinder.first,
      );
      expect(widgetFinder2, findsOneWidget);
      expect(inkWellSeason, findsOneWidget);

      await tester.tap(inkWellSeason);
      await tester.pump();

      expect(
        find.byType(TvSeasonBottomSheet, skipOffstage: false),
        findsOneWidget,
      );
      expect(find.byKey(const Key('season-sheet-unhandled')), findsOneWidget);
    });

    testWidgets('Should display season episode data and close',
        (WidgetTester tester) async {
      when(() => tvDetailBloc.state).thenReturn(TvDetailLoaded(
          data: tvDetailLoadedData.copyWith(
        seasonEpisodeState: RequestState.Loaded,
        seasonEpisode: tSeasonEpisode,
      )));

      final scrollFinder = find.byType(Scrollable);
      final widgetFinder = find.byKey(const Key('ListView-SeasonList'));
      final inkWellSeason =
          find.byKey(const Key('FetchSeasonEpisodeTv-inkwel-0'));
      final expandFinder =
          find.byKey(const Key('inkwell-expand'), skipOffstage: false);
      final backFinder = find.byIcon(Icons.close);

      await tester.pumpWidget(_makeTestableWidget(
        const TvDetailPage(id: tId),
      ));
      await tester.scrollUntilVisible(
        inkWellSeason,
        500.0,
        scrollable: scrollFinder.first,
      );
      expect(widgetFinder, findsOneWidget);
      expect(inkWellSeason, findsOneWidget);

      await tester.tap(inkWellSeason);
      await tester.pump();

      expect(
        find.byType(TvSeasonBottomSheet, skipOffstage: false),
        findsOneWidget,
      );
      expect(find.byKey(const Key('SeasonEpisode-ListTile-0')), findsOneWidget);

      expect(expandFinder, findsOneWidget);
      await tester.tap(expandFinder, warnIfMissed: false);
      await tester.pump();

      await tester.tap(backFinder, warnIfMissed: false);
      await tester.pump();
    });
  });
}
