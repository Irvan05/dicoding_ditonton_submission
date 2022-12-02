// ignore_for_file: use_key_in_widget_constructors, constant_identifier_names, library_private_types_in_public_api

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:tv/tv.dart';
import 'package:flutter/material.dart';
import 'package:watchlist/presentation/blocs/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:watchlist/presentation/blocs/watchlist_tv/watchlist_tv_bloc.dart';

class WatchlistPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist';

  final CategoryState initialTab;

  const WatchlistPage({this.initialTab = CategoryState.Movies});

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<WatchlistMovieBloc>(context).add(FetchWatchlistMovies());
      BlocProvider.of<WatchlistTvBloc>(context).add(FetchWatchlistTvs());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    BlocProvider.of<WatchlistMovieBloc>(context).add(FetchWatchlistMovies());
    BlocProvider.of<WatchlistTvBloc>(context).add(FetchWatchlistTvs());
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  int setInitialTab(tab) {
    switch (widget.initialTab) {
      case CategoryState.Movies:
        return 0;
      case CategoryState.TV:
        return 1;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: setInitialTab(widget.initialTab),
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Watchlist'),
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
        body: const Padding(
            padding: EdgeInsets.all(8.0),
            child: TabBarView(
              children: [
                MovieTabView(),
                TvTabView(),
              ],
            )),
      ),
    );
  }
}

class MovieTabView extends StatelessWidget {
  const MovieTabView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
      builder: (context, state) {
        if (state is WatchlistMovieLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is WatchlistMovieLoaded) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final movie = state.moviesData[index];
              return MovieCard(movie);
            },
            itemCount: state.moviesData.length,
          );
        } else if (state is WatchlistMovieError) {
          return Center(
            key: const Key('error_message_movie'),
            child: Text(state.error),
          );
        } else {
          return Center(
            key: const Key('movie-unhandled-text'),
            child: Text('unhandled state: ${state.toString()}'),
          );
        }
      },
    );
  }
}

class TvTabView extends StatelessWidget {
  const TvTabView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistTvBloc, WatchlistTvState>(
      builder: (context, state) {
        if (state is WatchlistTvLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is WatchlistTvLoaded) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final movie = state.tvsData[index];
              return TvCard(movie);
            },
            itemCount: state.tvsData.length,
          );
        } else if (state is WatchlistTvError) {
          return Center(
            key: const Key('error_message_tv'),
            child: Text(state.error),
          );
        } else {
          return Center(
            key: const Key('tv-unhandled-text'),
            child: Text('unhandled state: ${state.toString()}'),
          );
        }
      },
    );
  }
}
