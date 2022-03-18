import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';

import '../../domain/entities/article.dart';

part 'top_headlines_state.dart';

class ArticlesCubit extends Cubit<ArticlesState> {
  final ArticlesRepository repository;

  ArticlesCubit({required this.repository}) : super(TopHeadlinesInitial());

  void getTopHeadlines() async {
    try {
      emit(TopHeadlinesLoading());
      final topHeadlines = await repository.topHeadlines();
      if (topHeadlines.isSuccess) {
        emit(TopHeadlinesLoaded(topHeadlines.data));
      } else {
        emit(TopHeadlinesError());
      }
    } catch (e) {
      emit(TopHeadlinesError());
    }
  }
}
