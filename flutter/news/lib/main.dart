import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news/core/news_api_client.dart';
import 'package:news/core/news_database_client.dart';
import 'package:news/features/frontpage/data/datasource/articles_local_data_source.dart';
import 'package:news/features/frontpage/data/datasource/articles_remote_data_source.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';
import 'package:news/features/frontpage/domain/usecases/get_top_headlines.dart';
import 'package:news/features/frontpage/presentation/bloc/articles_cubit.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_state.dart';

void main() async {
  await dotenv.load(fileName: ".secrets_env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var dio = Dio();
    dio.options.queryParameters = {
      "apiKey": dotenv.env['NEWS_API_KEY'],
      "country": "us"
    };
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => ArticlesCubit(
          GetTopHeadlines(
            ArticlesRepository(
              ArticlesLocalDataSource(DummyDB()),
              ArticlesRemoteDataSource(NewsApiClient(dio)),
            ),
          ),
        )
          ..init()
          ..sync(),
        child: const MyHomePage(),
      ), //const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: BlocBuilder<ArticlesCubit, ArticlesState>(
        builder: (context, state) => Center(
          child: Text(
            state.when(
              initial: () => "Initial",
              loading: () => "Loading",
              loaded: (data) => "Items: ${data.length}",
              error: () => "Error",
            ),
          ),
        ),
      ),
    );
  }
}
