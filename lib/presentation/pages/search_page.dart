import 'package:core/core.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';
  final CategoryState initialTab;

  SearchPage({this.initialTab = CategoryState.Movies});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: setInitialTab(initialTab),
      length: 2,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('Search'),
            bottom: const TabBar(tabs: [
              Tab(
                icon: Icon(Icons.movie),
                text: 'Movies',
              ),
              Tab(
                icon: Icon(Icons.tv),
                text: 'Tvs',
              )
            ]),
          ),
          body: TabBarView(
            children: [
              MovieTabView(),
              TvTabView(),
            ],
          )),
    );
  }

  int setInitialTab(tab) {
    switch (initialTab) {
      case CategoryState.Movies:
        return 0;
      case CategoryState.TV:
        return 1;
      default:
        return 0;
    }
  }
}

class MovieTabView extends StatelessWidget {
  const MovieTabView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onSubmitted: (query) {
              Provider.of<MovieSearchNotifier>(context, listen: false)
                  .fetchMovieSearch(query);
            },
            decoration: InputDecoration(
              hintText: 'Search title',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.search,
          ),
          SizedBox(height: 16),
          Text(
            'Search Result',
            style: kHeading6,
          ),
          Consumer<MovieSearchNotifier>(
            builder: (context, data, child) {
              if (data.state == RequestState.Loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (data.state == RequestState.Loaded) {
                final result = data.searchResult;
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final movie = data.searchResult[index];
                      return MovieCard(movie);
                    },
                    itemCount: result.length,
                  ),
                );
              } else {
                return Expanded(
                  child: Container(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class TvTabView extends StatelessWidget {
  const TvTabView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onSubmitted: (query) {
              Provider.of<TvSearchNotifier>(context, listen: false)
                  .fetchTvSearch(query);
            },
            decoration: InputDecoration(
              hintText: 'Search title',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.search,
          ),
          SizedBox(height: 16),
          Text(
            'Search Result',
            style: kHeading6,
          ),
          Consumer<TvSearchNotifier>(
            builder: (context, data, child) {
              if (data.state == RequestState.Loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (data.state == RequestState.Loaded) {
                final result = data.searchResult;
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final tv = data.searchResult[index];
                      return TvCard(tv);
                    },
                    itemCount: result.length,
                  ),
                );
              } else {
                return Expanded(
                  child: Container(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
