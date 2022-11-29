import 'package:bloc_test/bloc_test.dart';
import 'package:core/commons/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/tv.dart';
import 'package:watchlist/presentation/blocs/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:watchlist/presentation/blocs/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:watchlist/presentation/pages/watchlist_page.dart';

class MockWatchlistMovieBloc
    extends MockBloc<WatchlistMovieEvent, WatchlistMovieState>
    implements WatchlistMovieBloc {}

class MockWatchlistTvBloc extends MockBloc<WatchlistTvEvent, WatchlistTvState>
    implements WatchlistTvBloc {}

class TestPush extends StatelessWidget {
  const TestPush({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          key: const Key('close'),
          child: const Text('')),
    );
  }
}

void main() {
  late WatchlistMovieBloc movieSearchBloc;
  late WatchlistTvBloc tvSearchBloc;

  setUp(() {
    movieSearchBloc = MockWatchlistMovieBloc();
    tvSearchBloc = MockWatchlistTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => movieSearchBloc,
        ),
        BlocProvider(
          create: (_) => tvSearchBloc,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  Widget testWidget = const MediaQuery(
      data: MediaQueryData(), child: MaterialApp(home: TestPush()));

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
  final tTv = Tv(
      backdropPath: "/56v2KjBlU4XaOv9rVYEQypROD7P.jpg",
      firstAirDate: DateTime(2016, 7, 15), //"2016-07-15",
      genreIds: const [18, 10765, 9648],
      id: 66732,
      name: "Stranger Things",
      originCountry: const ["US"],
      originalLanguage: "en",
      originalName: "Stranger Things",
      overview: "overview",
      popularity: 475.516,
      posterPath: "/49WJfeN0moxb9IPfGn8AIqMGskD.jpg",
      voteAverage: 8.6,
      voteCount: 14335);

  testWidgets('[movie] should display loading when bloc states are loading',
      (WidgetTester tester) async {
    when(() => movieSearchBloc.state).thenReturn(WatchlistMovieLoading());

    final progressBarFinder =
        find.byType(CircularProgressIndicator, skipOffstage: false);

    await tester.pumpWidget(_makeTestableWidget(
      const WatchlistPage(),
    ));

    expect(movieSearchBloc.state, WatchlistMovieLoading());
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('[movie] should display error when state is error',
      (WidgetTester tester) async {
    when(() => movieSearchBloc.state)
        .thenReturn(const WatchlistMovieError(error: 'error'));

    final widgetFinder = find.byKey(const Key('error_message_movie'));
    await tester.pumpWidget(_makeTestableWidget(
      const WatchlistPage(),
    ));

    expect(movieSearchBloc.state, const WatchlistMovieError(error: 'error'));
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('[movie] should display loaded data is loaded',
      (WidgetTester tester) async {
    when(() => movieSearchBloc.state).thenReturn(
      WatchlistMovieLoaded(moviesData: [tMovie]),
    );

    final widgetFinder = find.byType(MovieCard);
    await tester.pumpWidget(_makeTestableWidget(
      const WatchlistPage(),
    ));

    expect(
      movieSearchBloc.state,
      WatchlistMovieLoaded(moviesData: [tMovie]),
    );
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('[movie] should display unhandled text when state is not found',
      (WidgetTester tester) async {
    when(() => movieSearchBloc.state).thenReturn(MovieDummyFail());

    final widgetFinder = find.byKey(const Key('movie-unhandled-text'));
    await tester.pumpWidget(_makeTestableWidget(
      const WatchlistPage(),
    ));

    expect(movieSearchBloc.state, MovieDummyFail());
    expect(widgetFinder, findsOneWidget);
  });

  // testWidgets('[movie] should trigger event when textfield is changed',
  //     (WidgetTester tester) async {
  //   when(() => movieSearchBloc.state).thenReturn(WatchlistMovieLoading());

  //   final inputFinder = find.byType(TextField).first;
  //   await tester.pumpWidget(_makeTestableWidget(
  //     const WatchlistPage(),
  //   ));
  //   await tester.enterText(inputFinder, tQuery);
  //   await tester.pump(const Duration(seconds: 1));

  //   expect(movieSearchBloc.state, WatchlistMovieLoading());

  testWidgets('[tv] should display loading when bloc states are loading',
      (WidgetTester tester) async {
    when(() => movieSearchBloc.state).thenReturn(MovieDummyFail());
    when(() => tvSearchBloc.state).thenReturn(WatchlistTvLoading());

    final progressBarFinder =
        find.byType(CircularProgressIndicator, skipOffstage: false);
    await tester.pumpWidget(_makeTestableWidget(
      const WatchlistPage(
        initialTab: CategoryState.TV,
      ),
    ));

    expect(tvSearchBloc.state, WatchlistTvLoading());
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('[tv] should display error when state is error',
      (WidgetTester tester) async {
    when(() => movieSearchBloc.state).thenReturn(WatchlistMovieLoading());
    when(() => tvSearchBloc.state)
        .thenReturn(const WatchlistTvError(error: 'error'));

    final widgetFinder = find.byKey(const Key('error_message_tv'));
    await tester.pumpWidget(_makeTestableWidget(
      const WatchlistPage(
        initialTab: CategoryState.TV,
      ),
    ));

    expect(tvSearchBloc.state, const WatchlistTvError(error: 'error'));
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('[tv] should display loaded data is loaded',
      (WidgetTester tester) async {
    when(() => movieSearchBloc.state).thenReturn(WatchlistMovieLoading());
    when(() => tvSearchBloc.state).thenReturn(
      WatchlistTvLoaded(tvsData: [tTv]),
    );

    final widgetFinder = find.byType(TvCard);
    await tester.pumpWidget(_makeTestableWidget(
      const WatchlistPage(
        initialTab: CategoryState.TV,
      ),
    ));

    expect(
      tvSearchBloc.state,
      WatchlistTvLoaded(tvsData: [tTv]),
    );
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('[tv] should display unhandled text when state is not found',
      (WidgetTester tester) async {
    when(() => movieSearchBloc.state).thenReturn(WatchlistMovieLoading());
    when(() => tvSearchBloc.state).thenReturn(TvDummyFail());

    final widgetFinder = find.byKey(const Key('tv-unhandled-text'));
    await tester.pumpWidget(_makeTestableWidget(
      const WatchlistPage(
        initialTab: CategoryState.TV,
      ),
    ));

    expect(tvSearchBloc.state, TvDummyFail());
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('should trigger didPopNext', (WidgetTester tester) async {
    when(() => movieSearchBloc.state).thenReturn(MovieDummyFail());
    when(() => tvSearchBloc.state).thenReturn(TvDummyFail());

    final closeFinder = find.byKey(const Key('close'));

    await tester.pumpWidget(_makeTestableWidget(
      const WatchlistPage(
        initialTab: CategoryState.TV,
      ),
    ));

    await tester.pumpWidget(testWidget);
    expect(closeFinder, findsOneWidget);
    await tester.press(closeFinder);

    verify(() => tvSearchBloc.add(FetchWatchlistTvs())).called(1);
    verify(() => movieSearchBloc.add(FetchWatchlistMovies())).called(1);
  });
}
