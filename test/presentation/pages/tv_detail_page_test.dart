import 'package:core/utils/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_page_test.mocks.dart';

@GenerateMocks([TvDetailNotifier])
void main() {
  late MockTvDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTvDetailNotifier();
    // GoogleFonts.config.allowRuntimeFetching = false;
  });

  late BuildContext savedContext;
  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: Builder(builder: (BuildContext context) {
        savedContext = context;
        return body;
      })),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when tv not added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when tv is added to wathclist',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(true);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('Failed');

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('Should display page loading when tvState is loading',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loading);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
      'Should display recommendations and season list when page is loaded',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(true);

    final widgetListView = find.byType(ListView, skipOffstage: false);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(widgetListView, findsNWidgets(2));
  });

  testWidgets(
      'Should display recommendation loading when recommendation is loading',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loading);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('');

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));
    expect(find.byType(CircularProgressIndicator, skipOffstage: false),
        findsAtLeastNWidgets(1));
  });

  testWidgets(
      'Should display recommendation error loading when recommendation is error',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Error);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.message).thenReturn('');
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('');

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));
    expect(find.byKey(Key('recommendation error'), skipOffstage: false),
        findsOneWidget);
  });

  testWidgets(
      'Should display season sheet and listview after clicking season image',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('');
    when(mockNotifier.seasonEpisodeState).thenReturn(RequestState.Loaded);
    when(mockNotifier.seasonEpisode).thenReturn(testSeasonEpisode);
    // when()

    final inkWellSeason = find.byType(InkWell, skipOffstage: false);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));
    await tester.tap(inkWellSeason.first);
    showModalBottomSheet(
        context: savedContext,
        builder: (BuildContext context) => TvSeasonBottomSheet());
    await tester.pump();

    expect(find.byType(DraggableScrollableSheet, skipOffstage: false),
        findsAtLeastNWidgets(2));
    expect(find.byType(ListTile), findsAtLeastNWidgets(1));
    expect(find.byType(ListView), findsAtLeastNWidgets(1));
  });

  testWidgets('Should display loading when season detail is loading',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('');
    when(mockNotifier.seasonEpisodeState).thenReturn(RequestState.Loading);

    final inkWellSeason = find.byType(InkWell, skipOffstage: false);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));
    await tester.tap(inkWellSeason.first);
    showModalBottomSheet(
        context: savedContext,
        builder: (BuildContext context) => TvSeasonBottomSheet());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
  });

  testWidgets('Should display error message when season detail is error',
      (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<Tv>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('');
    when(mockNotifier.seasonEpisodeState).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('error');

    final inkWellSeason = find.byType(InkWell, skipOffstage: false);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));
    await tester.tap(inkWellSeason.first);
    showModalBottomSheet(
        context: savedContext,
        builder: (BuildContext context) => TvSeasonBottomSheet());
    await tester.pump();

    expect(find.byKey(Key('season sheet error'), skipOffstage: false),
        findsOneWidget);
  });
}
