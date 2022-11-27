import 'package:core/commons/utils/routes.dart';
// import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:flutter/material.dart';
import 'package:movie/movie.dart';
import 'package:tv/tv.dart';
import 'package:watchlist/watchlist.dart';

// import 'package:about/about.dart';

class HomeScaffoldDrawer extends StatelessWidget {
  final currentPath;
  const HomeScaffoldDrawer(this.currentPath, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const UserAccountsDrawerHeader(
          currentAccountPicture: CircleAvatar(
            backgroundImage: AssetImage('assets/circle-g.png'),
          ),
          accountName: Text('Ditonton'),
          accountEmail: Text('ditonton@dicoding.com'),
        ),
        ListTile(
          leading: const Icon(Icons.movie),
          title: const Text('Movies'),
          onTap: () {
            currentPath == HomeMoviePage.ROUTE_NAME
                ? Navigator.pop(context)
                : Navigator.pushReplacementNamed(
                    context, HomeMoviePage.ROUTE_NAME);
          },
        ),
        ListTile(
          leading: const Icon(Icons.tv),
          title: const Text('Tvs'),
          onTap: () {
            currentPath == HomeTvPage.ROUTE_NAME
                ? Navigator.pop(context)
                : Navigator.pushReplacementNamed(
                    context, HomeTvPage.ROUTE_NAME);
          },
        ),
        ListTile(
          leading: const Icon(Icons.save_alt),
          title: const Text('Watchlist'),
          onTap: () {
            Navigator.pushNamed(context, WATCHLIST_PAGE);
          },
        ),
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, ABOUT_ROUTE);
          },
          leading: const Icon(Icons.info_outline),
          title: const Text('About'),
        ),
      ],
    );
  }
}
