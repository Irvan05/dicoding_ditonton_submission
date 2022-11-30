// ignore_for_file: use_key_in_widget_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/blocs/home_movie/home_movie_bloc.dart';
import 'package:movie/presentation/blocs/popular_movies/popular_movies_bloc.dart';
import 'package:movie/presentation/blocs/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:movie/presentation/pages/home_movie_page.dart';

class MockHomeMovieBloc extends MockBloc<HomeMovieEvent, HomeMovieState>
    implements HomeMovieBloc {}

class MockPopularMoviesBloc
    extends MockBloc<PopularMoviesEvent, PopularMoviesState>
    implements PopularMoviesBloc {}

class MockTopRatedMoviesBloc
    extends MockBloc<TopRatedMoviesEvent, TopRatedMoviesState>
    implements TopRatedMoviesBloc {}

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
  late HomeMovieBloc homeMovieBloc;
  late PopularMoviesBloc popularMoviesBloc;
  late TopRatedMoviesBloc topRatedMoviesBloc;

  setUp(() {
    homeMovieBloc = MockHomeMovieBloc();
    popularMoviesBloc = MockPopularMoviesBloc();
    topRatedMoviesBloc = MockTopRatedMoviesBloc();
  });

  // ignore: no_leading_underscores_for_local_identifiers
  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => homeMovieBloc,
        ),
        BlocProvider(
          create: (_) => popularMoviesBloc,
        ),
        BlocProvider(
          create: (_) => topRatedMoviesBloc,
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

  final tMovie = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = [tMovie];

  testWidgets('should display loading when states are loading',
      (WidgetTester tester) async {
    when(() => homeMovieBloc.state).thenReturn(HomeMovieLoading());
    when(() => popularMoviesBloc.state).thenReturn(PopularMoviesLoading());
    when(() => topRatedMoviesBloc.state).thenReturn(TopRatedMoviesLoading());

    final progressBarFinder =
        find.byType(CircularProgressIndicator, skipOffstage: false);

    await tester.pumpWidget(_makeTestableWidget(
      HomeMoviePage(),
    ));

    expect(homeMovieBloc.state, HomeMovieLoading());
    expect(popularMoviesBloc.state, PopularMoviesLoading());
    expect(topRatedMoviesBloc.state, TopRatedMoviesLoading());
    expect(progressBarFinder, findsNWidgets(3));
  });

  testWidgets('should display error when states are error',
      (WidgetTester tester) async {
    when(() => homeMovieBloc.state)
        .thenReturn(const HomeMovieError(error: 'error'));
    when(() => popularMoviesBloc.state)
        .thenReturn(const PopularMoviesError(error: 'error'));
    when(() => topRatedMoviesBloc.state)
        .thenReturn(const TopRatedMoviesError(error: 'error'));

    final widgetFinder = find.byKey(const Key('now-playing-error'));
    final widgetFinder2 = find.byKey(const Key('popular-error'));
    final widgetFinder3 = find.byKey(const Key('top-rated-error'));
    await tester.pumpWidget(_makeTestableWidget(
      HomeMoviePage(),
    ));

    verify(() => homeMovieBloc.add(FetchNowPlayingMovies())).called(1);
    expect(homeMovieBloc.state, const HomeMovieError(error: 'error'));
    expect(popularMoviesBloc.state, const PopularMoviesError(error: 'error'));
    expect(topRatedMoviesBloc.state, const TopRatedMoviesError(error: 'error'));
    expect(widgetFinder, findsOneWidget);
    expect(widgetFinder2, findsOneWidget);
    expect(widgetFinder3, findsOneWidget);
  });

  testWidgets('should display loaded when states are loaded',
      (WidgetTester tester) async {
    when(() => homeMovieBloc.state)
        .thenReturn(HomeMovieLoaded(movies: tMovieList));
    when(() => popularMoviesBloc.state)
        .thenReturn(PopularMoviesLoaded(movies: tMovieList));
    when(() => topRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesLoaded(movies: tMovieList));

    final widgetFinder = find.byType(MovieList);
    await tester.pumpWidget(_makeTestableWidget(
      HomeMoviePage(),
    ));

    expect(
      homeMovieBloc.state,
      HomeMovieLoaded(movies: tMovieList),
    );
    expect(
      popularMoviesBloc.state,
      PopularMoviesLoaded(movies: tMovieList),
    );
    expect(
      topRatedMoviesBloc.state,
      TopRatedMoviesLoaded(movies: tMovieList),
    );
    expect(widgetFinder, findsNWidgets(3));
  });

  testWidgets('hould display unhandled text when state is not found',
      (WidgetTester tester) async {
    when(() => homeMovieBloc.state).thenReturn(HomeMovieDummy());
    when(() => popularMoviesBloc.state).thenReturn(PopularMoviesDummy());
    when(() => topRatedMoviesBloc.state).thenReturn(TopRatedMoviesDummy());

    final widgetFinder = find.byKey(const Key('now-playing-unhandled'));
    final widgetFinder2 = find.byKey(const Key('popular-unhandled'));
    final widgetFinder3 = find.byKey(const Key('top-rated-unhandled'));
    await tester.pumpWidget(_makeTestableWidget(
      HomeMoviePage(),
    ));

    expect(homeMovieBloc.state, HomeMovieDummy());
    expect(popularMoviesBloc.state, PopularMoviesDummy());
    expect(topRatedMoviesBloc.state, TopRatedMoviesDummy());
    expect(widgetFinder, findsOneWidget);
    expect(widgetFinder2, findsOneWidget);
    expect(widgetFinder3, findsOneWidget);
  });

  testWidgets('test push search', (WidgetTester tester) async {
    when(() => homeMovieBloc.state)
        .thenReturn(HomeMovieLoaded(movies: tMovieList));
    when(() => popularMoviesBloc.state)
        .thenReturn(PopularMoviesLoaded(movies: tMovieList));
    when(() => topRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesLoaded(movies: tMovieList));

    final iconFinder = find.byIcon(Icons.search);

    await tester.pumpWidget(_makeTestableWidget(
      HomeMoviePage(),
    ));
    await tester.tap(iconFinder);
  });

  testWidgets('test push Popular-inkwell', (WidgetTester tester) async {
    when(() => homeMovieBloc.state)
        .thenReturn(HomeMovieLoaded(movies: tMovieList));
    when(() => popularMoviesBloc.state)
        .thenReturn(PopularMoviesLoaded(movies: tMovieList));
    when(() => topRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesLoaded(movies: tMovieList));

    final widgetFinder = find.byKey(const Key('Popular-inkwell'));

    await tester.pumpWidget(_makeTestableWidget(
      HomeMoviePage(),
    ));
    await tester.tap(widgetFinder);
  });
  testWidgets('test push Top Rated-inkwell', (WidgetTester tester) async {
    when(() => homeMovieBloc.state)
        .thenReturn(HomeMovieLoaded(movies: tMovieList));
    when(() => popularMoviesBloc.state)
        .thenReturn(PopularMoviesLoaded(movies: tMovieList));
    when(() => topRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesLoaded(movies: tMovieList));

    final widgetFinder = find.byKey(const Key('Top Rated-inkwell'));

    await tester.pumpWidget(_makeTestableWidget(
      HomeMoviePage(),
    ));
    await tester.tap(widgetFinder);
  });
  testWidgets('test push detail page', (WidgetTester tester) async {
    when(() => homeMovieBloc.state)
        .thenReturn(HomeMovieLoaded(movies: tMovieList));
    when(() => popularMoviesBloc.state)
        .thenReturn(PopularMoviesLoaded(movies: tMovieList));
    when(() => topRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesLoaded(movies: tMovieList));

    final widgetFinder = find.byKey(const Key('now-playing-0'));

    await tester.pumpWidget(_makeTestableWidget(
      HomeMoviePage(),
    ));
    await tester.tap(widgetFinder);
  });
}
