import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/blocs/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';

class MockTopRatedMoviesBloc
    extends MockBloc<TopRatedMoviesEvent, TopRatedMoviesState>
    implements TopRatedMoviesBloc {}

void main() {
  late TopRatedMoviesBloc topRatedMoviesBloc;

  setUp(() {
    topRatedMoviesBloc = MockTopRatedMoviesBloc();
  });

  // ignore: no_leading_underscores_for_local_identifiers
  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => topRatedMoviesBloc,
        ),
      ],
      child: MaterialApp(
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
    when(() => topRatedMoviesBloc.state).thenReturn(TopRatedMoviesLoading());

    final progressBarFinder =
        find.byType(CircularProgressIndicator, skipOffstage: false);

    await tester.pumpWidget(_makeTestableWidget(
      TopRatedMoviesPage(),
    ));

    expect(topRatedMoviesBloc.state, TopRatedMoviesLoading());
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('should display error when state are error',
      (WidgetTester tester) async {
    when(() => topRatedMoviesBloc.state)
        .thenReturn(const TopRatedMoviesError(error: 'error'));

    final widgetFinder = find.byKey(const Key('error_message'));
    await tester.pumpWidget(_makeTestableWidget(
      TopRatedMoviesPage(),
    ));

    expect(topRatedMoviesBloc.state, const TopRatedMoviesError(error: 'error'));
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('should display loaded when state are loaded',
      (WidgetTester tester) async {
    when(() => topRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesLoaded(movies: tMovieList));

    final widgetFinder = find.byType(MovieCard);
    await tester.pumpWidget(_makeTestableWidget(
      TopRatedMoviesPage(),
    ));

    verify(() => topRatedMoviesBloc.add(FetchTopRatedMovies())).called(1);
    expect(topRatedMoviesBloc.state, TopRatedMoviesLoaded(movies: tMovieList));
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('should display unhandled text when state is not found',
      (WidgetTester tester) async {
    when(() => topRatedMoviesBloc.state).thenReturn(TopRatedMoviesDummy());

    final widgetFinder = find.byKey(const Key('unhandled_message'));
    await tester.pumpWidget(_makeTestableWidget(
      TopRatedMoviesPage(),
    ));

    expect(topRatedMoviesBloc.state, TopRatedMoviesDummy());
    expect(widgetFinder, findsOneWidget);
  });
}
