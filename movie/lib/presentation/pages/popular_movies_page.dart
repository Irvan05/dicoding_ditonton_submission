import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/blocs/popular_movies/popular_movies_bloc.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        // Provider.of<PopularMoviesNotifier>(context, listen: false)
        //     .fetchPopularMovies());
        BlocProvider.of<PopularMoviesBloc>(context).add(FetchPopularMovies()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
              builder: (context, state) {
            if (state is PopularMoviesLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  return MovieCard(movie);
                },
                itemCount: state.movies.length,
              );
            } else if (state is PopularMoviesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularMoviesError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.error),
              );
            } else {
              return Center(
                child: Text('Unhandled state ${state.toString()}'),
              );
            }
          })
          // Consumer<PopularMoviesNotifier>(
          //   builder: (context, data, child) {
          //     if (data.state == RequestState.Loading) {
          //       return Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     } else if (data.state == RequestState.Loaded) {
          //       return ListView.builder(
          //         itemBuilder: (context, index) {
          //           final movie = data.movies[index];
          //           return MovieCard(movie);
          //         },
          //         itemCount: data.movies.length,
          //       );
          //     } else {
          //       return Center(
          //         key: Key('error_message'),
          //         child: Text(data.message),
          //       );
          //     }
          //   },
          // ),
          ),
    );
  }
}
