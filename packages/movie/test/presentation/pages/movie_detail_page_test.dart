// ignore_for_file: avoid_print

import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/presentation/blocs/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

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
  late MovieDetailBloc movieDetailBloc;

  setUp(() {
    movieDetailBloc = MockMovieDetailBloc();
  });

  // ignore: no_leading_underscores_for_local_identifiers
  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => movieDetailBloc,
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
  const tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );
  const tAltMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 10,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );
  const tId = 1;
  final movieDetailLoadedData = MovieDetailLoadedData(
      movie: tMovieDetail,
      movieRecommendations: tMovieList,
      isRecommendationError: false,
      isAddedToWatchlist: false,
      watchlistMessage: '',
      recommendationError: '');
  final movieDetailLoadedDataAlt = MovieDetailLoadedData(
      movie: tAltMovieDetail,
      movieRecommendations: tMovieList,
      isRecommendationError: false,
      isAddedToWatchlist: false,
      watchlistMessage: '',
      recommendationError: '');

  testWidgets('should display loading when state are loading',
      (WidgetTester tester) async {
    when(() => movieDetailBloc.state).thenReturn(MovieDetailLoading());

    final progressBarFinder =
        find.byType(CircularProgressIndicator, skipOffstage: false);

    await tester.pumpWidget(_makeTestableWidget(
      const MovieDetailPage(id: tId),
    ));

    expect(movieDetailBloc.state, MovieDetailLoading());
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('should display error when state are error',
      (WidgetTester tester) async {
    when(() => movieDetailBloc.state)
        .thenReturn(MovieDetailError(error: 'error'));

    final widgetFinder = find.byKey(const Key('detail-error'));
    await tester.pumpWidget(_makeTestableWidget(
      const MovieDetailPage(id: tId),
    ));

    expect(movieDetailBloc.state, MovieDetailError(error: 'error'));
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('should display unhandled text when state is not found',
      (WidgetTester tester) async {
    when(() => movieDetailBloc.state).thenReturn(MovieDetailDummy());

    final widgetFinder = find.byKey(const Key('unhandler-error'));
    await tester.pumpWidget(_makeTestableWidget(
      const MovieDetailPage(id: tId),
    ));

    expect(movieDetailBloc.state, MovieDetailDummy());
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('should display loaded and recommendation when state are loaded',
      (WidgetTester tester) async {
    when(() => movieDetailBloc.state)
        .thenReturn(MovieDetailLoaded(data: movieDetailLoadedData));

    final widgetFinder = find.byType(DetailContent);
    final listviewFinder = find.byType(ListView, skipOffstage: false);
    final backFinder = find.byIcon(Icons.arrow_back);
    await tester.pumpWidget(_makeTestableWidget(
      const MovieDetailPage(id: tId),
    ));

    expect(
      movieDetailBloc.state,
      MovieDetailLoaded(data: movieDetailLoadedData),
    );
    expect(widgetFinder, findsOneWidget);
    expect(listviewFinder, findsOneWidget);
    expect(backFinder, findsOneWidget);
  });

  testWidgets(
      'should display recommnendation error when state are loaded and recommendation is error',
      (WidgetTester tester) async {
    when(() => movieDetailBloc.state).thenReturn(MovieDetailLoaded(
        data: movieDetailLoadedDataAlt.copyWith(isRecommendationError: true)));

    final widgetFinder = find.byType(DetailContent);
    final keyFinder =
        find.byKey(const Key('recommendation-error-text'), skipOffstage: false);
    await tester.pumpWidget(_makeTestableWidget(
      const MovieDetailPage(id: tId),
    ));

    expect(
      movieDetailBloc.state,
      MovieDetailLoaded(
          data: movieDetailLoadedDataAlt.copyWith(isRecommendationError: true)),
    );
    expect(widgetFinder, findsOneWidget);
    expect(keyFinder, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    final expectedStates = [
      MovieDetailLoaded(
          data: movieDetailLoadedDataAlt.copyWith(
              watchlistMessage: 'Added to Watchlist'))
    ];

    whenListen(
      movieDetailBloc,
      Stream.fromIterable(expectedStates),
      initialState: MovieDetailLoading(),
    );

    await tester.pumpWidget(_makeTestableWidget(
      const MovieDetailPage(id: tId),
    ));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    final expectedStates = [
      MovieDetailLoaded(
          data: movieDetailLoadedDataAlt.copyWith(watchlistMessage: 'Failed'))
    ];

    whenListen(
      movieDetailBloc,
      Stream.fromIterable(expectedStates),
      initialState: MovieDetailLoading(),
    );

    await tester.pumpWidget(_makeTestableWidget(
      const MovieDetailPage(id: tId),
    ));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('add to watchlist event', (WidgetTester tester) async {
    when(() => movieDetailBloc.state)
        .thenReturn(MovieDetailLoaded(data: movieDetailLoadedData));

    final buttonFinder = find.byIcon(Icons.add).first;

    await tester.pumpWidget(_makeTestableWidget(
      const MovieDetailPage(id: tId),
    ));
    await tester.tap(buttonFinder);
    await tester.pump();

    verify(() => movieDetailBloc.add(const AddWatchlist(movie: tMovieDetail)))
        .called(1);
  });

  testWidgets('remove to watchlist event', (WidgetTester tester) async {
    when(() => movieDetailBloc.state).thenReturn(MovieDetailLoaded(
        data: movieDetailLoadedData.copyWith(isAddedToWatchlist: true)));

    final buttonFinder = find.byIcon(Icons.check).first;

    await tester.pumpWidget(_makeTestableWidget(
      const MovieDetailPage(id: tId),
    ));
    await tester.tap(buttonFinder);
    await tester.pump();

    verify(() =>
            movieDetailBloc.add(const RemoveFromWatchlist(movie: tMovieDetail)))
        .called(1);
  });

  testWidgets('test open movie detail', (WidgetTester tester) async {
    when(() => movieDetailBloc.state)
        .thenReturn(MovieDetailLoaded(data: movieDetailLoadedData));

    final scrollFinder = find.byType(Scrollable);
    final widgetFinder = find
        .byKey(const Key('recommendation-inkwell-0'), skipOffstage: false)
        .first;

    await tester.pumpWidget(_makeTestableWidget(
      const MovieDetailPage(id: tId),
    ));
    await tester.scrollUntilVisible(
      widgetFinder,
      500.0,
      scrollable: scrollFinder.first,
    );
    await tester.tap(widgetFinder);
  });

  testWidgets('test pop movie detail', (WidgetTester tester) async {
    when(() => movieDetailBloc.state)
        .thenReturn(MovieDetailLoaded(data: movieDetailLoadedData));

    final widgetFinder = find.byIcon(Icons.arrow_back).first;

    await tester.pumpWidget(_makeTestableWidget(
      const MovieDetailPage(id: tId),
    ));
    await tester.tap(widgetFinder);
  });
}
