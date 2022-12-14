library movie;

//data
//datasources
export 'data/datasources/db/database_helper_movie.dart';
export 'data/datasources/movie_local_data_source.dart';
export 'data/datasources/movie_remote_data_source.dart';
//models
export 'data/models/movie_detail_model.dart';
export 'data/models/movie_model.dart';
export 'data/models/movie_response.dart';
export 'data/models/movie_table.dart';
//repo
export 'data/repositories/movie_repository_impl.dart';

//domain
//entities
export 'domain/entities/movie_detail.dart';
export 'domain/entities/movie.dart';
//repo
export 'domain/repositories/movie_repository.dart';
//usecases
export 'domain/usecases/get_movie_detail.dart';
export 'domain/usecases/get_movie_recommendations.dart';
export 'domain/usecases/get_now_playing_movies.dart';
export 'domain/usecases/get_popular_movies.dart';
export 'domain/usecases/get_top_rated_movies.dart';

//presentation
//pages
export 'presentation/pages/home_movie_page.dart';
export 'presentation/pages/movie_detail_page.dart';
export 'presentation/pages/popular_movies_page.dart';
export 'presentation/pages/top_rated_movies_page.dart';
//provider
//bloc
export 'presentation/blocs/home_movie/home_movie_bloc.dart';
export 'presentation/blocs/movie_detail/movie_detail_bloc.dart';
export 'presentation/blocs/popular_movies/popular_movies_bloc.dart';
export 'presentation/blocs/top_rated_movies/top_rated_movies_bloc.dart';
//widgets
export 'presentation/widgets/movie_card_list.dart';
