import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'home_movie_page_test.mocks.dart';

@GenerateMocks([MovieListNotifier])
void main() {
  late MockMovieListNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockMovieListNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<MovieListNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('should display loading when states are loading',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.Loading);
    when(mockNotifier.popularMoviesState).thenReturn(RequestState.Loading);
    when(mockNotifier.topRatedMoviesState).thenReturn(RequestState.Loading);

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

    expect(progressBarFinder, findsNWidgets(3));
  });

  testWidgets('should display movie list when states are Loaded',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.Loaded);
    when(mockNotifier.nowPlayingMovies).thenReturn(testMovieList);
    when(mockNotifier.popularMoviesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.popularMovies).thenReturn(testMovieList);
    when(mockNotifier.topRatedMoviesState).thenReturn(RequestState.Loaded);
    when(mockNotifier.topRatedMovies).thenReturn(testMovieList);
    when(mockNotifier.message).thenReturn('');

    final movieListFinder = find.byType(MovieList);

    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

    expect(movieListFinder, findsNWidgets(3));
  });

  testWidgets('should display text failed when states are error',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.Error);
    when(mockNotifier.popularMoviesState).thenReturn(RequestState.Error);
    when(mockNotifier.topRatedMoviesState).thenReturn(RequestState.Error);
    when(mockNotifier.message).thenReturn('');

    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

    expect(find.byKey(Key('now playing error')), findsOneWidget);
    expect(find.byKey(Key('popular error')), findsOneWidget);
    expect(find.byKey(Key('top rated error')), findsOneWidget);
  });

  testWidgets('should display drawer when hamburger icon is pressed',
      (WidgetTester tester) async {
    when(mockNotifier.nowPlayingState).thenReturn(RequestState.Loading);
    when(mockNotifier.popularMoviesState).thenReturn(RequestState.Loading);
    when(mockNotifier.topRatedMoviesState).thenReturn(RequestState.Loading);

    final drawerButton = find.byIcon(Icons.menu);

    await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
    await tester.tap(drawerButton.first);
    await tester.pump();

    expect(find.byType(Drawer), findsOneWidget);
  });
}
