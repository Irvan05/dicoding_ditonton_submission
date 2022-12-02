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
//presentation
//pages
export 'presentation/pages/home_tv_page.dart';
export 'presentation/pages/on_the_air_tvs_page.dart';
export 'presentation/pages/popular_tv_page.dart';
export 'presentation/pages/top_rated_tvs_page.dart';
export 'presentation/pages/tv_detail_page.dart';
//bloc
export 'presentation/blocs/on_the_air_tvs/on_the_air_tvs_bloc.dart';
export 'presentation/blocs/popular_tvs/popular_tvs_bloc.dart';
export 'presentation/blocs/top_rated_tvs/top_rated_tvs_bloc.dart';
export 'presentation/blocs/tv_detail/tv_detail_bloc.dart';
//widgets
export 'presentation/widgets/tv_card_list.dart';
