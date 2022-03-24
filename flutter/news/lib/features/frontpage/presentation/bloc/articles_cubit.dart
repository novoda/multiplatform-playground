import 'package:bloc/bloc.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_state.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_viewstate.dart';

class ArticlesCubit extends Cubit<ArticlesState> {
  final ArticlesRepository repository;

  ArticlesCubit({required this.repository})
      : super(const ArticlesState.initial());

  void getTopHeadlines() async {
    emit(const ArticlesState.loading());

    final result = await repository.topHeadlines();
    result.fold(
        ifSuccess: (data) => {
              emit(ArticlesState.loaded(
                  viewState: data
                      .take(10)
                      .map(
                        (article) => TopHeadlineViewState(
                          title: article.title,
                          url: article.url,
                          imageUrl: article.urlToImage,
                        ),
                      )
                      .toList()))
            },
        ifFailure: (failure) => emit(const ArticlesState.error()));
  }
}
