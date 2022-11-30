// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/blocs/popular_tvs/popular_tvs_bloc.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';

class PopularTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv';

  @override
  _PopularTvsPageState createState() => _PopularTvsPageState();
}

class _PopularTvsPageState extends State<PopularTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => BlocProvider.of<PopularTvsBloc>(context).add(FetchPopularTvs()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Tvs'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<PopularTvsBloc, PopularTvsState>(
              builder: (context, state) {
            if (state is PopularTvsLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.tvs[index];
                  return TvCard(tv);
                },
                itemCount: state.tvs.length,
              );
            } else if (state is PopularTvsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularTvsError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.error),
              );
            } else {
              return Center(
                key: const Key('unhandled_message'),
                child: Text('Unhandled state ${state.toString()}'),
              );
            }
          })),
    );
  }
}
