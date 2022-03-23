import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_viewstate.dart';

part 'top_headlines_state.dart';

class ArticlesCubit extends Cubit<ArticlesState> {
  final ArticlesRepository repository;

  ArticlesCubit({required this.repository}) : super(TopHeadlinesInitial());

  void getTopHeadlines() async {
    emit(TopHeadlinesLoading());

    final result = await repository.topHeadlines();
    result.fold(
        ifSuccess: (data) => {
              emit(TopHeadlinesLoaded(data
                  .take(10)
                  .map(
                    (article) => TopHeadlineViewState(
                      article.title,
                      article.url,
                      article.urlToImage,
                    ),
                  )
                  .toList()))
            },
        ifFailure: (failure) => emit(TopHeadlinesError()));
  }
}
