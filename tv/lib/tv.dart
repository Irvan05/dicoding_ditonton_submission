library tv;

//data
//datasource
export 'data/datasources/db/database_helper_tv.dart';
export 'data/datasources/tv_local_data_source.dart';
export 'data/datasources/tv_remote_data_source.dart';
//models
export 'data/models/season_episode_model.dart';
export 'data/models/season_model.dart';
export 'data/models/tv_detail_model.dart';
export 'data/models/tv_model.dart';
export 'data/models/tv_response.dart';
export 'data/models/tv_table.dart';
//repo
export 'data/repositories/tv_repository_impl.dart';

//domain
//entities
export 'domain/entities/season_episode.dart';
export 'domain/entities/season.dart';
export 'domain/entities/tv_detail.dart';
export 'domain/entities/tv.dart';
//repo
export 'domain/repositories/tv_repository.dart';
//usecases
export 'domain/usecases/get_on_the_air_tvs.dart';
export 'domain/usecases/get_popular_tvs.dart';
export 'domain/usecases/get_season_detail_tv.dart';
export 'domain/usecases/get_top_rated_tvs.dart';
export 'domain/usecases/get_tv_detail.dart';
export 'domain/usecases/get_tv_recommendations.dart';
export 'domain/usecases/get_watchlist_status_tv.dart';
export 'domain/usecases/get_watchlist_tvs.dart';
export 'domain/usecases/remove_watchlist_tv.dart';
export 'domain/usecases/save_watchlist_tv.dart';

//presentation
//pages
export 'presentation/pages/home_tv_page.dart';
export 'presentation/pages/on_the_air_tvs_page.dart';
export 'presentation/pages/popular_tv_page.dart';
export 'presentation/pages/top_rated_tvs_page.dart';
export 'presentation/pages/tv_detail_page.dart';
//provider
export 'presentation/provider/on_the_air_tvs_notifier.dart';
export 'presentation/provider/popular_tvs_notifier.dart';
export 'presentation/provider/top_rated_tvs_notifier.dart';
export 'presentation/provider/tv_detail_notifier.dart';
export 'presentation/provider/tv_list_notifier.dart';
export 'presentation/provider/watchlist_tv_notifier.dart';
//widgets
export 'presentation/widgets/tv_card_list.dart';
