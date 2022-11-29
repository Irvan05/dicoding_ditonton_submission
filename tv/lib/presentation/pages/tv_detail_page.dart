import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/entities/season.dart';
import 'package:tv/domain/entities/season_episode.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tv/presentation/blocs/tv_detail/tv_detail_bloc.dart';

class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv_detail';

  final int id;
  const TvDetailPage({required this.id});

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<TvDetailBloc>(context).add(FetchTvDetail(id: widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TvDetailBloc, TvDetailState>(
        listener: (context, state) {
          if (state is TvDetailLoaded) {
            final message = state.data.watchlistMessage;
            if (message == TvDetailBloc.watchlistAddSuccessMessage ||
                message == TvDetailBloc.watchlistRemoveSuccessMessage) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(message)));
            } else if (message != '' &&
                message != TvDetailBloc.watchlistAddSuccessMessage &&
                message != TvDetailBloc.watchlistRemoveSuccessMessage) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(message),
                    );
                  });
            }
          }
        },
        builder: (context, state) {
          if (state is TvDetailLoaded) {
            return SafeArea(
              child: DetailContent(
                state.data.tv,
                state.data.tvRecommendations,
                state.data.isAddedToWatchlist,
              ),
            );
          } else if (state is TvDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvDetailError) {
            return Expanded(
              child: Center(
                child: Text(
                  state.error,
                ),
              ),
            );
          } else {
            return Text('Unhandled State ${state.toString()}');
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail tv;
  final List<Tv> recommendations;
  final bool isAddedWatchlist;

  const DetailContent(this.tv, this.recommendations, this.isAddedWatchlist,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tv.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  context
                                      .read<TvDetailBloc>()
                                      .add(AddWatchlist(tv: tv));
                                } else {
                                  context
                                      .read<TvDetailBloc>()
                                      .add(RemoveFromWatchlist(tv: tv));
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(tv.genres),
                            ),
                            Text(
                              '${tv.seasons.length} Season',
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tv.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Season List',
                              style: kHeading6,
                            ),
                            SeasonList(id: tv.id, seasons: tv.seasons),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            TvRecommendations(recommendations: recommendations),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}

class SeasonList extends StatelessWidget {
  const SeasonList({
    Key? key,
    required this.id,
    required this.seasons,
  }) : super(key: key);

  final int id;
  final List<Season> seasons;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 208,
      child: Card(
          child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: seasons.length,
        itemBuilder: (context, index) {
          final season = seasons[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () {
                Future.microtask(() {
                  context.read<TvDetailBloc>().add(FetchSeasonEpisodeTv(
                      id: id, seasonNum: season.seasonNumber));
                });
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return const Center(child: TvSeasonBottomSheet());
                  },
                );
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://image.tmdb.org/t/p/w500${season.posterPath}',
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Text('${season.name}'),
                  Text('${season.episodeCount} Episode')
                ],
              ),
            ),
          );
        },
      )),
    );
  }
}

class TvSeasonBottomSheet extends StatelessWidget {
  const TvSeasonBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
      child: SafeArea(
        child: DraggableScrollableSheet(
            initialChildSize: 1,
            maxChildSize: 1,
            minChildSize: 0.8,
            snap: true,
            builder: (BuildContext context, ScrollController scrollController) {
              return Stack(
                children: [
                  BlocBuilder<TvDetailBloc, TvDetailState>(
                      builder: (context, state) {
                    if (state is TvDetailLoaded) {
                      if (state.data.seasonEpisodeState ==
                          RequestState.Loaded) {
                        return SeasonEpisodeBody(
                            seasonEpisode: state.data.seasonEpisode!);
                      } else if (state.data.seasonEpisodeState ==
                          RequestState.Loading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state.data.seasonEpisodeState ==
                          RequestState.Error) {
                        return Text(
                          state.data.seasonEpisodeError,
                          key: const Key('season sheet error'),
                        );
                      } else {
                        return Center(
                          child: Text(
                              'Unhandled state ${state.data.seasonEpisodeState.toString()}'),
                        );
                      }
                    } else {
                      return Center(
                        child: Text('Unhandled state ${state.toString()}'),
                      );
                    }
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(5),
                          backgroundColor: Colors.black,
                        ),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  )
                ],
              );
            }),
      ),
    );
  }
}

class SeasonEpisodeBody extends StatefulWidget {
  final SeasonEpisode seasonEpisode;

  const SeasonEpisodeBody({
    Key? key,
    required this.seasonEpisode,
  }) : super(key: key);

  @override
  State<SeasonEpisodeBody> createState() => _SeasonEpisodeBodyState();
}

class _SeasonEpisodeBodyState extends State<SeasonEpisodeBody> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            '${widget.seasonEpisode.name}',
            style: kHeading5,
          ),
          subtitle: Column(
            children: [
              Text(
                '${widget.seasonEpisode.overview}',
                maxLines: _isExpanded ? 100 : 1,
                textAlign: TextAlign.justify,
                overflow: TextOverflow.ellipsis,
              ),
              widget.seasonEpisode.overview != null &&
                      widget.seasonEpisode.overview != '' &&
                      widget.seasonEpisode.overview!.isNotEmpty
                  ? InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            _isExpanded ? "show less" : "show more",
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                    )
                  : const SizedBox(),
              const Divider(
                thickness: 2,
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: widget.seasonEpisode.episodes == null
                  ? 0
                  : widget.seasonEpisode.episodes!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Container(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: CachedNetworkImage(
                          imageUrl:
                              'https://image.tmdb.org/t/p/w500${widget.seasonEpisode.episodes![index].stillPath}',
                          placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.seasonEpisode.episodes![index].name}',
                        style: kHeading5,
                      ),
                      Text(
                        '${widget.seasonEpisode.episodes![index].overview}',
                      ),
                      const Divider(),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class TvRecommendations extends StatelessWidget {
  const TvRecommendations({
    Key? key,
    required this.recommendations,
  }) : super(key: key);

  final List<Tv> recommendations;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TvDetailBloc, TvDetailState>(
      builder: (context, state) {
        if (state is TvDetailLoaded) {
          if (state.data.isRecommendationError) {
            return Center(
              child: Text(
                state.data.recommendationError,
              ),
            );
          } else {
            return SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final tv = recommendations[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                          context,
                          TvDetailPage.ROUTE_NAME,
                          arguments: tv.id,
                        );
                      },
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: recommendations.length,
              ),
            );
          }
        } else if (state is TvDetailLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Text('Unhandled State ${state.toString()}');
        }
      },
    );
  }
}
