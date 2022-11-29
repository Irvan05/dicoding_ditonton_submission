import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/blocs/on_the_air_tvs/on_the_air_tvs_bloc.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';

class OnTheAirTvsPage extends StatefulWidget {
  static const ROUTE_NAME = '/on-the-air-tvs';

  @override
  _OnTheAirTvsPageState createState() => _OnTheAirTvsPageState();
}

class _OnTheAirTvsPageState extends State<OnTheAirTvsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        BlocProvider.of<OnTheAirTvsBloc>(context).add(FetchOnTheAirTvs()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('On The Air Tvs'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<OnTheAirTvsBloc, OnTheAirTvsState>(
              builder: (context, state) {
            if (state is OnTheAirTvsLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.tvs[index];
                  return TvCard(tv);
                },
                itemCount: state.tvs.length,
              );
            } else if (state is OnTheAirTvsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is OnTheAirTvsError) {
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
