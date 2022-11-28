// ignore_for_file: use_key_in_widget_constructors

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:search/search.dart';
// import 'package:search/presentation/provider/movie_search_notifier.dart';
// import 'package:search/presentation/provider/tv_search_notifier.dart';
import 'package:tv/tv.dart';

class SearchPage extends StatelessWidget {
  final CategoryState initialTab;

  const SearchPage({this.initialTab = CategoryState.Movies});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: setInitialTab(initialTab),
      length: 2,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('Search'),
            bottom: TabBar(
                onTap: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                tabs: const [
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
          body: const TabBarView(
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
            onChanged: (query) {
              context.read<MovieSearchBloc>().add(OnMovieQueryChanged(query));
            },
            decoration: const InputDecoration(
              hintText: 'Search title',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.search,
          ),
          const SizedBox(height: 16),
          Text(
            'Search Result',
            style: kHeading6,
          ),
          BlocBuilder<MovieSearchBloc, MovieSearchState>(
            builder: (context, state) {
              if (state is MovieSearchLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    key: Key('loading-movie-indicator'),
                  ),
                );
              } else if (state is MovieSearchHasData) {
                final result = state.result;
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final movie = result[index];
                      return MovieCard(movie);
                    },
                    itemCount: result.length,
                  ),
                );
              } else if (state is MovieSearchEmpty) {
                return Column(
                  children: const [
                    Divider(),
                    Center(
                      child: Text(
                        'No result found...',
                        key: Key('no-result-movie'),
                      ),
                    )
                  ],
                );
              } else if (state is MovieSearchError) {
                return Expanded(
                  child: Center(
                    child: Text(
                      state.message,
                      key: const Key('movie-error-text'),
                    ),
                  ),
                );
              } else {
                return const Expanded(
                  child: Center(),
                );
              }
            },
          ),

          // Consumer<MovieSearchNotifier>(
          //   builder: (context, data, child) {
          //     if (data.state == RequestState.Loading) {
          //       return const Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     } else if (data.state == RequestState.Loaded) {
          //       final result = data.searchResult;
          //       return Expanded(
          //         child: ListView.builder(
          //           padding: const EdgeInsets.all(8),
          //           itemBuilder: (context, index) {
          //             final movie = data.searchResult[index];
          //             return MovieCard(movie);
          //           },
          //           itemCount: result.length,
          //         ),
          //       );
          //     } else {
          //       return Expanded(
          //         child: Container(),
          //       );
          //     }
          //   },
          // ),
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
            // onSubmitted: (query) {
            //   Provider.of<TvSearchNotifier>(context, listen: false)
            //       .fetchTvSearch(query);
            // },
            onChanged: (query) {
              context.read<TvSearchBloc>().add(OnTvQueryChanged(query));
            },
            decoration: const InputDecoration(
              hintText: 'Search title',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.search,
          ),
          const SizedBox(height: 16),
          Text(
            'Search Result',
            style: kHeading6,
          ),
          BlocBuilder<TvSearchBloc, TvSearchState>(
            builder: (context, state) {
              if (state is TvSearchLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TvSearchHasData) {
                final result = state.result;
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final movie = result[index];
                      return TvCard(movie);
                    },
                    itemCount: result.length,
                  ),
                );
              } else if (state is TvSearchEmpty) {
                return Column(
                  children: const [
                    Divider(),
                    Center(
                      child: Text('No result found...'),
                    )
                  ],
                );
              } else if (state is TvSearchError) {
                return Expanded(
                  child: Center(
                    child: Text(state.message),
                  ),
                );
              } else {
                return Expanded(
                  child: Container(),
                );
              }
            },
          ),
          // Consumer<TvSearchNotifier>(
          //   builder: (context, data, child) {
          //     if (data.state == RequestState.Loading) {
          //       return const Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     } else if (data.state == RequestState.Loaded) {
          //       final result = data.searchResult;
          //       return Expanded(
          //         child: ListView.builder(
          //           padding: const EdgeInsets.all(8),
          //           itemBuilder: (context, index) {
          //             final tv = data.searchResult[index];
          //             return TvCard(tv);
          //           },
          //           itemCount: result.length,
          //         ),
          //       );
          //     } else {
          //       return Expanded(
          //         child: Container(),
          //       );
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
