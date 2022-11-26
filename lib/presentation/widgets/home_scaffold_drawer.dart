import 'package:core/utils/routes.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/home_tv_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:flutter/material.dart';

// import 'package:about/about.dart';

class HomeScaffoldDrawer extends StatelessWidget {
  final currentPath;
  HomeScaffoldDrawer(this.currentPath);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserAccountsDrawerHeader(
          currentAccountPicture: CircleAvatar(
            backgroundImage: AssetImage('assets/circle-g.png'),
          ),
          accountName: Text('Ditonton'),
          accountEmail: Text('ditonton@dicoding.com'),
        ),
        ListTile(
          leading: Icon(Icons.movie),
          title: Text('Movies'),
          onTap: () {
            currentPath == HomeMoviePage.ROUTE_NAME
                ? Navigator.pop(context)
                : Navigator.pushReplacementNamed(
                    context, HomeMoviePage.ROUTE_NAME);
          },
        ),
        ListTile(
          leading: Icon(Icons.tv),
          title: Text('Tvs'),
          onTap: () {
            currentPath == HomeTvPage.ROUTE_NAME
                ? Navigator.pop(context)
                : Navigator.pushReplacementNamed(
                    context, HomeTvPage.ROUTE_NAME);
          },
        ),
        ListTile(
          leading: Icon(Icons.save_alt),
          title: Text('Watchlist'),
          onTap: () {
            Navigator.pushNamed(context, WatchlistPage.ROUTE_NAME);
          },
        ),
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, ABOUT_ROUTE);
          },
          leading: Icon(Icons.info_outline),
          title: Text('About'),
        ),
      ],
    );
  }
}
