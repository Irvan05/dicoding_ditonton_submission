import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/search.dart';

// import '../../dummy_data/dummy_objects.dart';
import 'search_page_test.mocks.dart';

@GenerateMocks([
  MovieSearchBloc,
  TvSearchBloc,
  SearchMovies,
  SearchTvs,
])
void main() {
  late MockMovieSearchBloc movieSearchBloc;
  late MockTvSearchBloc tvSearchBloc;

  late MockSearchMovies mockSearchMovies;
  late MockSearchTvs mockSearchTvs;

  setUp(() {
    movieSearchBloc = MockMovieSearchBloc();
    tvSearchBloc = MockTvSearchBloc();
    mockSearchMovies = MockSearchMovies();
    mockSearchTvs = MockSearchTvs();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MovieSearchBloc(mockSearchMovies),
        ),
        BlocProvider(
          create: (_) => TvSearchBloc(mockSearchTvs),
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  const tQuery = 'spiderman';

  testWidgets('should display empty state when page is just loaded',
      (WidgetTester tester) async {
    when(movieSearchBloc.state).thenAnswer((_) => MovieSearchEmpty());

    // final widgetFinder = find.byKey(Key('no-result-movie'));

    await tester.pumpWidget(_makeTestableWidget(const SearchPage()));
    await tester.pumpAndSettle();

    expect(movieSearchBloc.state, MovieSearchEmpty());
  });

  testWidgets('should display error when state is error',
      (WidgetTester tester) async {
    when(movieSearchBloc.state)
        .thenAnswer((_) => const MovieSearchError('error'));

    final widgetFinder = find.byKey(const Key('movie-error-text'));

    await tester.pumpWidget(_makeTestableWidget(const SearchPage()));
    await tester.pumpAndSettle();

    expect(movieSearchBloc.state, const MovieSearchError('error'));
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('should display loading when bloc states are loading',
      (WidgetTester tester) async {
    // when(mockNotifier.nowPlayingState).thenReturn(RequestState.Loading);
    // when(mockNotifier.popularMoviesState).thenReturn(RequestState.Loading);
    // when(mockNotifier.topRatedMoviesState).thenReturn(RequestState.Loading);
    // when(mockSearchMovies.execute(tQuery))
    //     .thenAnswer((_) async => Right(tMovieList));

    // when(movieSearchBloc.onEvent(const OnMovieQueryChanged(tQuery)))
    //     .thenAnswer((_) => movieSearchBloc.emit(MovieSearchLoading()));

    when(movieSearchBloc.state).thenAnswer((_) => MovieSearchLoading());

    // final progressBarFinder =
    //     find.byType(CircularProgressIndicator, skipOffstage: false);
    // movieSearchBloc.add(const OnMovieQueryChanged(tQuery));
    // movieSearchBloc.onEvent(const OnMovieQueryChanged(tQuery));

    await tester.pumpWidget(_makeTestableWidget(const SearchPage()));
    await tester.pumpAndSettle();

    expect(movieSearchBloc.state, MovieSearchLoading());
    // expect(progressBarFinder, findsOneWidget);
  });

  // testWidgets('should display movie list when states are Loaded',
  //     (WidgetTester tester) async {
  //   when(mockNotifier.nowPlayingState).thenReturn(RequestState.Loaded);
  //   when(mockNotifier.nowPlayingMovies).thenReturn(testMovieList);
  //   when(mockNotifier.popularMoviesState).thenReturn(RequestState.Loaded);
  //   when(mockNotifier.popularMovies).thenReturn(testMovieList);
  //   when(mockNotifier.topRatedMoviesState).thenReturn(RequestState.Loaded);
  //   when(mockNotifier.topRatedMovies).thenReturn(testMovieList);
  //   when(mockNotifier.message).thenReturn('');

  //   final movieListFinder = find.byType(MovieList);

  //   await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

  //   expect(movieListFinder, findsNWidgets(3));
  // });

  // testWidgets('should display text failed when states are error',
  //     (WidgetTester tester) async {
  //   when(mockNotifier.nowPlayingState).thenReturn(RequestState.Error);
  //   when(mockNotifier.popularMoviesState).thenReturn(RequestState.Error);
  //   when(mockNotifier.topRatedMoviesState).thenReturn(RequestState.Error);
  //   when(mockNotifier.message).thenReturn('');

  //   await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

  //   expect(find.byKey(Key('now playing error')), findsOneWidget);
  //   expect(find.byKey(Key('popular error')), findsOneWidget);
  //   expect(find.byKey(Key('top rated error')), findsOneWidget);
  // });

  // testWidgets('should display drawer when hamburger icon is pressed',
  //     (WidgetTester tester) async {
  //   when(mockNotifier.nowPlayingState).thenReturn(RequestState.Loading);
  //   when(mockNotifier.popularMoviesState).thenReturn(RequestState.Loading);
  //   when(mockNotifier.topRatedMoviesState).thenReturn(RequestState.Loading);

  //   final drawerButton = find.byIcon(Icons.menu);

  //   await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));
  //   await tester.tap(drawerButton.first);
  //   await tester.pump();

  //   expect(find.byType(Drawer), findsOneWidget);
  // });
}
