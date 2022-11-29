import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/presentation/blocs/on_the_air_tvs/on_the_air_tvs_bloc.dart';
import 'package:tv/presentation/blocs/popular_tvs/popular_tvs_bloc.dart';
import 'package:tv/presentation/blocs/top_rated_tvs/top_rated_tvs_bloc.dart';
import 'package:tv/presentation/pages/on_the_air_tvs_page.dart';
import 'package:tv/presentation/pages/popular_tv_page.dart';
import 'package:tv/presentation/pages/top_rated_tvs_page.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'package:flutter/material.dart';

class HomeTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/home-tv';

  const HomeTvPage({super.key});

  @override
  _HomeTvPageState createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<OnTheAirTvsBloc>(context).add(FetchOnTheAirTvs());
      BlocProvider.of<PopularTvsBloc>(context).add(FetchPopularTvs());
      BlocProvider.of<TopRatedTvsBloc>(context).add(FetchTopRatedTvs());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(child: HomeScaffoldDrawer(HomeTvPage.ROUTE_NAME)),
      appBar: AppBar(
        title: const Text('Tvs'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                SEARCH_ROUTE,
                arguments: CategoryState.TV,
              );
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                title: 'On The Air',
                onTap: () =>
                    Navigator.pushNamed(context, OnTheAirTvsPage.ROUTE_NAME),
              ),
              BlocBuilder<OnTheAirTvsBloc, OnTheAirTvsState>(
                  builder: (context, state) {
                if (state is OnTheAirTvsLoaded) {
                  return TvList(state.tvs);
                } else if (state is OnTheAirTvsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is OnTheAirTvsError) {
                  return Center(
                    key: const Key('on the air error'),
                    child: Text(state.error),
                  );
                } else {
                  return Center(
                    child: Text('Unhandled state ${state.toString()}'),
                  );
                }
              }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTvsPage.ROUTE_NAME),
              ),
              BlocBuilder<PopularTvsBloc, PopularTvsState>(
                  builder: (context, state) {
                if (state is PopularTvsLoaded) {
                  return TvList(state.tvs);
                } else if (state is PopularTvsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PopularTvsError) {
                  return Center(
                    key: const Key('popular error'),
                    child: Text(state.error),
                  );
                } else {
                  return Center(
                    child: Text('Unhandled state ${state.toString()}'),
                  );
                }
              }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedTvsPage.ROUTE_NAME),
              ),
              BlocBuilder<TopRatedTvsBloc, TopRatedTvsState>(
                  builder: (context, state) {
                if (state is TopRatedTvsLoaded) {
                  return TvList(state.tvs);
                } else if (state is TopRatedTvsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TopRatedTvsError) {
                  return Center(
                    key: const Key('top rated error'),
                    child: Text(state.error),
                  );
                } else {
                  return Center(
                    child: Text('Unhandled state ${state.toString()}'),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvList extends StatelessWidget {
  final List<Tv> tvs;

  const TvList(this.tvs, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvs[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvs.length,
      ),
    );
  }
}
