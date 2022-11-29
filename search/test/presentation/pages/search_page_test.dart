import 'package:bloc_test/bloc_test.dart';
import 'package:core/commons/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';
import 'package:search/presentation/blocs/movie_search_bloc.dart';
import 'package:search/presentation/blocs/tv_search_bloc.dart';
import 'package:search/presentation/pages/search_page.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/tv.dart';

// import '../../dummy_data/dummy_objects.dart';

class MockMovieSearchBloc extends MockBloc<MovieSearchEvent, MovieSearchState>
    implements MovieSearchBloc {}

class MockTvSearchBloc extends MockBloc<TvSearchEvent, TvSearchState>
    implements TvSearchBloc {}

void main() {
  late MovieSearchBloc movieSearchBloc;
  late TvSearchBloc tvSearchBloc;

  setUp(() {
    movieSearchBloc = MockMovieSearchBloc();
    tvSearchBloc = MockTvSearchBloc();
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

  const tQuery = 'spiderman';
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
    when(() => movieSearchBloc.state).thenReturn(MovieSearchLoading());

    final progressBarFinder =
        find.byType(CircularProgressIndicator, skipOffstage: false);

    await tester.pumpWidget(_makeTestableWidget(
      const SearchPage(),
    ));
    // await tester.pumpAndSettle();

    expect(movieSearchBloc.state, MovieSearchLoading());
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('[movie] should display empty state when state is empty',
      (WidgetTester tester) async {
    when(() => movieSearchBloc.state).thenReturn(MovieSearchEmpty());

    final widgetFinder = find.byKey(const Key('no-result-movie'));
    await tester.pumpWidget(_makeTestableWidget(
      const SearchPage(),
    ));

    expect(movieSearchBloc.state, MovieSearchEmpty());
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('[movie] should display error when state is error',
      (WidgetTester tester) async {
    when(() => movieSearchBloc.state)
        .thenReturn(const MovieSearchError('error'));

    final widgetFinder = find.byKey(const Key('movie-error-text'));
    await tester.pumpWidget(_makeTestableWidget(
      const SearchPage(),
    ));

    expect(movieSearchBloc.state, const MovieSearchError('error'));
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('[movie] should display MovieSearchHasData data is loaded',
      (WidgetTester tester) async {
    when(() => movieSearchBloc.state).thenReturn(MovieSearchHasData([tMovie]));

    final widgetFinder = find.byType(MovieCard);
    await tester.pumpWidget(_makeTestableWidget(
      const SearchPage(),
    ));

    expect(movieSearchBloc.state, MovieSearchHasData([tMovie]));
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('[movie] should trigger event when textfield is changed',
      (WidgetTester tester) async {
    when(() => movieSearchBloc.state).thenReturn(MovieSearchLoading());

    final inputFinder = find.byType(TextField).first;
    await tester.pumpWidget(_makeTestableWidget(
      const SearchPage(),
    ));
    await tester.enterText(inputFinder, tQuery);
    await tester.pump(const Duration(seconds: 1));

    expect(movieSearchBloc.state, MovieSearchLoading());
    verify(() => movieSearchBloc.add(const OnMovieQueryChanged(tQuery)))
        .called(1);
  });

  testWidgets('should hide keyboard when tab is clicked',
      (WidgetTester tester) async {
    when(() => movieSearchBloc.state).thenReturn(MovieSearchLoading());

    final inputFinder = find.byType(TextField).first;
    final widgetFinder = find.byIcon(Icons.movie).first;

    await tester.pumpWidget(_makeTestableWidget(
      const SearchPage(),
    ));
    await tester.showKeyboard(inputFinder);
    await tester.tap(widgetFinder);
  });

  testWidgets('[movie] should display unhandled text when state is not found',
      (WidgetTester tester) async {
    when(() => movieSearchBloc.state).thenReturn(MovieDummyFail());

    final widgetFinder = find.byKey(const Key('movie-unhandled-text'));
    await tester.pumpWidget(_makeTestableWidget(
      const SearchPage(),
    ));

    expect(movieSearchBloc.state, MovieDummyFail());
    expect(widgetFinder, findsOneWidget);
  });
  ////////////////////////////////////

  testWidgets('[tv] should display empty state when state is empty',
      (WidgetTester tester) async {
    when(() => tvSearchBloc.state).thenReturn(TvSearchEmpty());

    final widgetFinder = find.byKey(const Key('no-result-tv'));
    await tester.pumpWidget(_makeTestableWidget(
      const SearchPage(
        initialTab: CategoryState.TV,
      ),
    ));

    expect(tvSearchBloc.state, TvSearchEmpty());
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('[tv] should display error when state is error',
      (WidgetTester tester) async {
    when(() => tvSearchBloc.state).thenReturn(const TvSearchError('error'));

    final widgetFinder = find.byKey(const Key('tv-error-text'));
    await tester.pumpWidget(_makeTestableWidget(
      const SearchPage(
        initialTab: CategoryState.TV,
      ),
    ));

    expect(tvSearchBloc.state, const TvSearchError('error'));
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('[tv] should display TvSearchHasData data is loaded',
      (WidgetTester tester) async {
    when(() => tvSearchBloc.state).thenReturn(TvSearchHasData([tTv]));

    final widgetFinder = find.byType(TvCard);
    await tester.pumpWidget(_makeTestableWidget(
      const SearchPage(
        initialTab: CategoryState.TV,
      ),
    ));

    expect(tvSearchBloc.state, TvSearchHasData([tTv]));
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('[tv] should trigger event when textfield is changed',
      (WidgetTester tester) async {
    when(() => tvSearchBloc.state).thenReturn(TvSearchLoading());

    final inputFinder = find.byType(TextField).first;
    await tester.pumpWidget(_makeTestableWidget(
      const SearchPage(
        initialTab: CategoryState.TV,
      ),
    ));
    await tester.enterText(inputFinder, tQuery);
    await tester.pump(const Duration(seconds: 1));

    expect(tvSearchBloc.state, TvSearchLoading());
    verify(() => tvSearchBloc.add(const OnTvQueryChanged(tQuery))).called(1);
  });

  testWidgets('[tv] should display unhandled text when state is not found',
      (WidgetTester tester) async {
    when(() => tvSearchBloc.state).thenReturn(TvDummyFail());

    final widgetFinder = find.byKey(const Key('tv-unhandled-text'));
    await tester.pumpWidget(_makeTestableWidget(
      const SearchPage(
        initialTab: CategoryState.TV,
      ),
    ));

    expect(tvSearchBloc.state, TvDummyFail());
    expect(widgetFinder, findsOneWidget);
  });
}
