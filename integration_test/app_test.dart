import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/main.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/main.dart' as app;
import 'package:ditonton/injection.dart' as di;

void main() {
  testWidgets('open popular movie page and return to home', (tester) async {
    if (di.isInit)
      runApp(MyApp());
    else
      app.main();

    await tester.pumpAndSettle();
    final movieListFinder = find.byType(MovieList, skipOffstage: false);
    expect(movieListFinder, findsNWidgets(3));

    final popularPageButton = find.byKey(Key('Popular-inkwell'));
    await tester.tap(popularPageButton);
    await tester.pumpAndSettle();
    expect(find.byType(MovieCard), findsAtLeastNWidgets(1));

    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
    expect(find.byType(CachedNetworkImage), findsAtLeastNWidgets(1));
    expect(find.byType(DraggableScrollableSheet), findsAtLeastNWidgets(1));

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.byType(MovieCard), findsAtLeastNWidgets(1));

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(movieListFinder, findsNWidgets(3));
  });

  testWidgets('open top rated movie page and return to home', (tester) async {
    if (di.isInit)
      runApp(MyApp());
    else
      app.main();

    await tester.pumpAndSettle();
    final movieListFinder = find.byType(MovieList, skipOffstage: false);
    expect(movieListFinder, findsNWidgets(3));

    final topRatedPageButton = find.byKey(Key('Top Rated-inkwell'));
    await tester.tap(topRatedPageButton);
    await tester.pumpAndSettle();
    expect(find.byType(MovieCard), findsAtLeastNWidgets(1));

    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
    expect(find.byType(CachedNetworkImage), findsAtLeastNWidgets(1));
    expect(find.byType(DraggableScrollableSheet), findsAtLeastNWidgets(1));

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.byType(MovieCard), findsAtLeastNWidgets(1));

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(movieListFinder, findsNWidgets(3));
  });

  testWidgets('open search page and search for movie', (tester) async {
    if (di.isInit)
      runApp(MyApp());
    else
      app.main();

    await tester.pumpAndSettle();
    final movieListFinder = find.byType(MovieList, skipOffstage: false);
    expect(movieListFinder, findsNWidgets(3));

    final searchIcon = find.byIcon(Icons.search);
    expect(searchIcon, findsOneWidget);
    await tester.tap(searchIcon);
    await tester.pumpAndSettle();
    expect(find.byType(TabBar), findsOneWidget);
    final searchInput = find.byType(TextField);
    expect(searchInput, findsOneWidget);

    await tester.enterText(searchInput, 'avengers');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.byType(MovieCard), findsAtLeastNWidgets(1));

    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
    expect(find.byType(CachedNetworkImage), findsAtLeastNWidgets(1));
    expect(find.byType(DraggableScrollableSheet), findsAtLeastNWidgets(1));

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.byType(MovieCard), findsAtLeastNWidgets(1));

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(movieListFinder, findsNWidgets(3));
  });

  testWidgets('open movie detail, add to watchlist, and check watchlist',
      (tester) async {
    if (di.isInit)
      runApp(MyApp());
    else
      app.main();

    await tester.pumpAndSettle();
    final movieListFinder = find.byType(MovieList, skipOffstage: false);
    expect(movieListFinder, findsNWidgets(3));

    // open movie detail
    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
    final watchlistIconAdd = find.byIcon(Icons.add);
    expect(watchlistIconAdd, findsOneWidget);

    //tap watchlist icon to add
    await tester.tap(watchlistIconAdd.first);
    await tester.pumpAndSettle();
    final watchlistIconCheck = find.byIcon(Icons.check);
    expect(watchlistIconCheck, findsOneWidget);

    // back to menu
    final backIcon = find.byIcon(Icons.arrow_back);
    await tester.tap(backIcon);
    await tester.pumpAndSettle();
    expect(movieListFinder, findsNWidgets(3));

    // open drawer
    final drawerButton = find.byIcon(Icons.menu);
    await tester.tap(drawerButton.first);
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsOneWidget);

    // tap watchlist page
    final watchlistIcon = find.byIcon(Icons.save_alt);
    await tester.tap(watchlistIcon.first);
    await tester.pumpAndSettle();
    expect(find.byType(TabBar), findsOneWidget);
    expect(find.byType(MovieCard), findsAtLeastNWidgets(1));

    // open first watchlist
    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
    expect(watchlistIconCheck, findsOneWidget);

    // tapi watchlist icon to remove
    await tester.tap(watchlistIconCheck);
    await tester.pumpAndSettle();
    expect(watchlistIconAdd, findsOneWidget);

    // back to watchlist page
    await tester.tap(backIcon);
    await tester.pumpAndSettle();
    expect(find.byType(TabBar), findsOneWidget);
    expect(find.byType(MovieCard), findsNothing);

    // back to main menu
    await tester.tap(backIcon);
    await tester.pumpAndSettle();
    expect(movieListFinder, findsNWidgets(3));
  });
}
