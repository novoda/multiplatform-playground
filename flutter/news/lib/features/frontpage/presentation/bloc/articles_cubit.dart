import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_viewstate.dart';

part 'top_headlines_state.dart';

class ArticlesCubit extends Cubit<ArticlesState> {
  final ArticlesRepository repository;

  ArticlesCubit({required this.repository}) : super(TopHeadlinesInitial());

  void getTopHeadlines() async {
    emit(TopHeadlinesLoading());
    final topHeadlines = await repository.topHeadlines();
    if (topHeadlines.isSuccess) {
      emit(TopHeadlinesLoaded(topHeadlines.data.take(10)
          .map((e) => TopHeadlineViewState(e.title, e.url, e.urlToImage)).toList()));
    } else {
      emit(TopHeadlinesError(topHeadlines.failure.message));
    }
  }
}
