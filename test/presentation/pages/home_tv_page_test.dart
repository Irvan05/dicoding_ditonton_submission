import 'package:core/utils/state_enum.dart';
import 'package:ditonton/presentation/pages/home_tv_page.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'home_tv_page_test.mocks.dart';

@GenerateMocks([TvListNotifier])
void main() {
  late MockTvListNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTvListNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvListNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('should display loading when states are loading',
      (WidgetTester tester) async {
    when(mockNotifier.onTheAirState).thenReturn(RequestState.Loading);
    when(mockNotifier.popularTvsState).thenReturn(RequestState.Loading);
    when(mockNotifier.topRatedTvsState).thenReturn(RequestState.Loading);

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));

    expect(progressBarFinder, findsNWidgets(3));
  });

  testWidgets('should display tv list when states are Loaded',
      (WidgetTester tester) async {
    when(mockNotifier.onTheAirState).thenReturn(RequestState.Loaded);
    when(mockNotifier.onTheAirTvs).thenReturn(testTvList);
    when(mockNotifier.popularTvsState).thenReturn(RequestState.Loaded);
    when(mockNotifier.popularTvs).thenReturn(testTvList);
    when(mockNotifier.topRatedTvsState).thenReturn(RequestState.Loaded);
    when(mockNotifier.topRatedTvs).thenReturn(testTvList);
    when(mockNotifier.message).thenReturn('');

    final tvListFinder = find.byType(TvList);

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));

    expect(tvListFinder, findsNWidgets(3));
  });

  testWidgets('should display text failed when states are error',
      (WidgetTester tester) async {
    when(mockNotifier.onTheAirState).thenReturn(RequestState.Error);
    when(mockNotifier.popularTvsState).thenReturn(RequestState.Error);
    when(mockNotifier.topRatedTvsState).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('');

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));

    expect(find.byKey(Key('on the air error')), findsOneWidget);
    expect(find.byKey(Key('popular error')), findsOneWidget);
    expect(find.byKey(Key('top rated error')), findsOneWidget);
  });

  testWidgets('should display drawer when hamburger icon is pressed',
      (WidgetTester tester) async {
    when(mockNotifier.onTheAirState).thenReturn(RequestState.Loading);
    when(mockNotifier.popularTvsState).thenReturn(RequestState.Loading);
    when(mockNotifier.topRatedTvsState).thenReturn(RequestState.Loading);

    final drawerButton = find.byIcon(Icons.menu);

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));
    await tester.tap(drawerButton.first);
    await tester.pump();

    expect(find.byType(Drawer), findsOneWidget);
  });
}
