import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:news/features/frontpage/data/datasource/articles_local_data_source.dart';
import 'package:news/features/frontpage/data/datasource/articles_remote_data_source.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';
import 'package:news/features/frontpage/presentation/bloc/articles_cubit.dart';

import 'core/http_client.dart';
import 'core/news_api_client.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerFactory(() => ArticlesCubit(repository: getIt()));

  getIt.registerLazySingleton(
    () =>
        ArticlesRepository(localDataSource: getIt(), remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton(() => ArticlesLocalDataSource(getIt()));

  getIt.registerLazySingleton(() => ArticlesRemoteDataSource(client: getIt()));

  getIt.registerLazySingleton(() => const JsonCodec());

  getIt.registerLazySingleton(() => NewsApiClient(getIt()));

  getIt.registerLazySingleton(() => createDio());
}
