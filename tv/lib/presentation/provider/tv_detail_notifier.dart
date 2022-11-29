// import 'package:tv/domain/entities/season_episode.dart';
// import 'package:tv/domain/entities/tv.dart';
// import 'package:tv/domain/entities/tv_detail.dart';
// import 'package:tv/domain/usecases/get_season_detail_tv.dart';
// import 'package:tv/domain/usecases/get_tv_detail.dart';
// import 'package:tv/domain/usecases/get_tv_recommendations.dart';
// import 'package:core/core.dart';
// import 'package:watchlist/watchlist.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// class TvDetailNotifier extends ChangeNotifier {
//   static const watchlistAddSuccessMessage = 'Added to Watchlist';
//   static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

//   final GetTvDetail getTvDetail;
//   final GetTvRecommendations getTvRecommendations;
//   final GetWatchListStatusTv getWatchListStatusTv;
//   final SaveWatchlistTv saveWatchlistTv;
//   final RemoveWatchlistTv removeWatchlistTv;
//   final GetSeasonDetailTv getSeasonDetailTv;

//   TvDetailNotifier(
//       {required this.getTvDetail,
//       required this.getTvRecommendations,
//       required this.getWatchListStatusTv,
//       required this.saveWatchlistTv,
//       required this.removeWatchlistTv,
//       required this.getSeasonDetailTv});

//   late TvDetail _tv;
//   TvDetail get tv => _tv;

//   RequestState _tvState = RequestState.Empty;
//   RequestState get tvState => _tvState;

//   List<Tv> _tvRecommendations = [];
//   List<Tv> get tvRecommendations => _tvRecommendations;

//   RequestState _recommendationState = RequestState.Empty;
//   RequestState get recommendationState => _recommendationState;

//   late SeasonEpisode _seasonEpisode;
//   SeasonEpisode get seasonEpisode => _seasonEpisode;

//   RequestState _seasonEpisodeState = RequestState.Empty;
//   RequestState get seasonEpisodeState => _seasonEpisodeState;

//   String _message = '';
//   String get message => _message;

//   bool _isAddedtoWatchlist = false;
//   bool get isAddedToWatchlist => _isAddedtoWatchlist;

//   Future<void> fetchTvDetail(int id) async {
//     _seasonEpisodeState = RequestState.Empty;
//     _tvState = RequestState.Loading;
//     notifyListeners();
//     final detailResult = await getTvDetail.execute(id);
//     final recommendationResult = await getTvRecommendations.execute(id);
//     detailResult.fold(
//       (failure) {
//         _tvState = RequestState.Error;
//         _message = failure.message;
//         notifyListeners();
//       },
//       (tv) {
//         _recommendationState = RequestState.Loading;
//         _tv = tv;
//         notifyListeners();
//         recommendationResult.fold(
//           (failure) {
//             _recommendationState = RequestState.Error;
//             _message = failure.message;
//           },
//           (tvs) {
//             _recommendationState = RequestState.Loaded;
//             _tvRecommendations = tvs;
//           },
//         );
//         _tvState = RequestState.Loaded;
//         notifyListeners();
//       },
//     );
//   }

//   Future<void> fetchSeasonDetailTv(
//     int id,
//     int seasonNum,
//     // BuildContext context, Widget bottomSheet
//   ) async {
//     _seasonEpisodeState = RequestState.Loading;
//     notifyListeners();
//     final detailResult = await getSeasonDetailTv.execute(id, seasonNum);
//     detailResult.fold(
//       (failure) {
//         _seasonEpisodeState = RequestState.Error;
//         _message = failure.message;
//         notifyListeners();
//       },
//       (seasonEpisode) {
//         _seasonEpisode = seasonEpisode;
//         _seasonEpisodeState = RequestState.Loaded;
//         notifyListeners();
//         // showModalBottomSheet(
//         //   isScrollControlled: true,
//         //   context: context,
//         //   builder: (BuildContext context) {
//         //     return Center(child: bottomSheet);
//         //   },
//         // );
//       },
//     );
//   }

//   String _watchlistMessage = '';
//   String get watchlistMessage => _watchlistMessage;

//   Future<void> addWatchlist(TvDetail tv) async {
//     final result = await saveWatchlistTv.execute(tv);

//     await result.fold(
//       (failure) async {
//         _watchlistMessage = failure.message;
//       },
//       (successMessage) async {
//         _watchlistMessage = successMessage;
//       },
//     );

//     await loadWatchlistStatus(tv.id);
//   }

//   Future<void> removeFromWatchlist(TvDetail tv) async {
//     final result = await removeWatchlistTv.execute(tv);

//     await result.fold(
//       (failure) async {
//         _watchlistMessage = failure.message;
//       },
//       (successMessage) async {
//         _watchlistMessage = successMessage;
//       },
//     );

//     await loadWatchlistStatus(tv.id);
//   }

//   Future<void> loadWatchlistStatus(int id) async {
//     final result = await getWatchListStatusTv.execute(id);
//     _isAddedtoWatchlist = result;
//     notifyListeners();
//   }
// }
