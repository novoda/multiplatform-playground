import 'package:get_it/get_it.dart';
import 'package:news/core/news_database_client.dart';
import 'package:news/features/frontpage/data/datasource/articles_local_data_source.dart';
import 'package:news/features/frontpage/data/datasource/articles_remote_data_source.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';
import 'package:news/features/frontpage/domain/usecases/get_top_headlines.dart';
import 'package:news/features/frontpage/presentation/bloc/articles_cubit.dart';

import 'core/news_api_client.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerFactory(() => ArticlesCubit(useCase: getIt()));

  getIt.registerLazySingleton(() => GetTopHeadlines(repository: getIt()));

  getIt.registerLazySingleton(
    () =>
        ArticlesRepository(localDataSource: getIt(), remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton(() => ArticlesLocalDataSource(db: getIt()));

  getIt.registerLazySingleton(() => ArticlesRemoteDataSource(client: getIt()));

  getIt.registerLazySingleton<DB>(() => DummyDB());

  getIt.registerLazySingleton(() => NewsApiClient.create());
}
