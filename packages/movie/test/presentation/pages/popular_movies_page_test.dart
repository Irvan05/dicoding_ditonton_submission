// ignore_for_file: avoid_print

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/blocs/popular_movies/popular_movies_bloc.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';

class MockPopularMoviesBloc
    extends MockBloc<PopularMoviesEvent, PopularMoviesState>
    implements PopularMoviesBloc {}

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
  late PopularMoviesBloc popularMoviesBloc;

  setUp(() {
    popularMoviesBloc = MockPopularMoviesBloc();
  });

  // ignore: no_leading_underscores_for_local_identifiers
  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => popularMoviesBloc,
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

  testWidgets('should display loading when state are loading',
      (WidgetTester tester) async {
    when(() => popularMoviesBloc.state).thenReturn(PopularMoviesLoading());

    final progressBarFinder =
        find.byType(CircularProgressIndicator, skipOffstage: false);

    await tester.pumpWidget(_makeTestableWidget(
      PopularMoviesPage(),
    ));

    expect(popularMoviesBloc.state, PopularMoviesLoading());
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('should display error when state are error',
      (WidgetTester tester) async {
    when(() => popularMoviesBloc.state)
        .thenReturn(const PopularMoviesError(error: 'error'));

    final widgetFinder = find.byKey(const Key('error_message'));
    await tester.pumpWidget(_makeTestableWidget(
      PopularMoviesPage(),
    ));

    expect(popularMoviesBloc.state, const PopularMoviesError(error: 'error'));
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('should display loaded when state are loaded',
      (WidgetTester tester) async {
    when(() => popularMoviesBloc.state)
        .thenReturn(PopularMoviesLoaded(movies: tMovieList));

    final widgetFinder = find.byType(MovieCard);
    await tester.pumpWidget(_makeTestableWidget(
      PopularMoviesPage(),
    ));

    verify(() => popularMoviesBloc.add(FetchPopularMovies())).called(1);
    expect(popularMoviesBloc.state, PopularMoviesLoaded(movies: tMovieList));
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('should display unhandled text when state is not found',
      (WidgetTester tester) async {
    when(() => popularMoviesBloc.state).thenReturn(PopularMoviesDummy());

    final widgetFinder = find.byKey(const Key('unhandled_message'));
    await tester.pumpWidget(_makeTestableWidget(
      PopularMoviesPage(),
    ));

    expect(popularMoviesBloc.state, PopularMoviesDummy());
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('test push search', (WidgetTester tester) async {
    when(() => popularMoviesBloc.state)
        .thenReturn(PopularMoviesLoaded(movies: tMovieList));

    final widgetFinder = find.byType(InkWell);

    await tester.pumpWidget(_makeTestableWidget(
      PopularMoviesPage(),
    ));
    await tester.tap(widgetFinder);
  });
}
