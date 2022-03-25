import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_logging_interceptor/dio_logging_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:news/features/frontpage/data/datasource/articles_local_data_source.dart';
import 'package:news/features/frontpage/data/datasource/articles_remote_data_source.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';
import 'package:news/features/frontpage/presentation/bloc/articles_cubit.dart';

import 'core/news_api_client.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerFactory(() => ArticlesCubit(repository: getIt()));

  getIt.registerLazySingleton(() =>
      ArticlesRepository(localDataSource: getIt(), remoteDataSource: getIt()));

  getIt.registerLazySingleton(() => ArticlesLocalDataSource(getIt()));

  getIt.registerLazySingleton(() => ArticlesRemoteDataSource(client: getIt()));

  getIt.registerLazySingleton(() => const JsonCodec());

  getIt.registerLazySingleton(() => NewsApiClient(getIt()));

  getIt.registerLazySingleton(() => createDio());
}

Dio createDio() {
  final dio = Dio();
  dio.options.headers['X-Api-Key'] = dotenv.env['NEWS_API_KEY'];
  dio.interceptors.add(
    DioLoggingInterceptor(
      level: Level.body,
      compact: false,
    ),
  );
  return dio;
}
