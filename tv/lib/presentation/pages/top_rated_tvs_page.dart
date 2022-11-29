import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/blocs/top_rated_tvs/top_rated_tvs_bloc.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';

class TopRatedTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv';

  @override
  _TopRatedTvsPageState createState() => _TopRatedTvsPageState();
}

class _TopRatedTvsPageState extends State<TopRatedTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        BlocProvider.of<TopRatedTvsBloc>(context).add(FetchTopRatedTvs()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Tvs'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<TopRatedTvsBloc, TopRatedTvsState>(
              builder: (context, state) {
            if (state is TopRatedTvsLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.tvs[index];
                  return TvCard(tv);
                },
                itemCount: state.tvs.length,
              );
            } else if (state is TopRatedTvsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedTvsError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.error),
              );
            } else {
              return Center(
                child: Text('Unhandled state ${state.toString()}'),
              );
            }
          })),
    );
  }
}
