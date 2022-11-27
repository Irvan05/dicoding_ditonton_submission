library movie;

//data
//datasources
export 'package:movie/data/datasources/db/database_helper_movie.dart';
export 'package:movie/data/datasources/movie_local_data_source.dart';
export 'package:movie/data/datasources/movie_remote_data_source.dart';
//models
export 'package:movie/data/models/movie_detail_model.dart';
export 'package:movie/data/models/movie_model.dart';
export 'package:movie/data/models/movie_response.dart';
export 'package:movie/data/models/movie_table.dart';
//repo
export 'package:movie/data/repositories/movie_repository_impl.dart';

//domain
//entities
export 'package:movie/domain/entities/movie_detail.dart';
export 'package:movie/domain/entities/movie.dart';
//repo
export 'package:movie/domain/repositories/movie_repository.dart';
//usecases
export 'package:movie/domain/usecases/get_movie_detail.dart';
export 'package:movie/domain/usecases/get_movie_recommendations.dart';
export 'package:movie/domain/usecases/get_now_playing_movies.dart';
export 'package:movie/domain/usecases/get_popular_movies.dart';
export 'package:movie/domain/usecases/get_top_rated_movies.dart';
export 'package:movie/domain/usecases/get_watchlist_movies.dart';
export 'package:movie/domain/usecases/get_watchlist_status.dart';
export 'package:movie/domain/usecases/remove_watchlist_movie.dart';
export 'package:movie/domain/usecases/save_watchlist_movie.dart';

//presentation
//pages
export 'package:movie/presentation/pages/home_movie_page.dart';
export 'package:movie/presentation/pages/movie_detail_page.dart';
export 'package:movie/presentation/pages/popular_movies_page.dart';
export 'package:movie/presentation/pages/top_rated_movies_page.dart';
//provider
export 'package:movie/presentation/provider/movie_detail_notifier.dart';
export 'package:movie/presentation/provider/movie_list_notifier.dart';
export 'package:movie/presentation/provider/popular_movies_notifier.dart';
export 'package:movie/presentation/provider/top_rated_movies_notifier.dart';
export 'package:movie/presentation/provider/watchlist_movie_notifier.dart';
//widgets
export 'package:movie/presentation/widgets/movie_card_list.dart';
