import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:news/core/language_extensions.dart';
import 'package:news/features/frontpage/domain/usecases/get_top_headlines.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_state.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_viewstate.dart';

class ArticlesCubit extends Cubit<ArticlesState> {
  final GetTopHeadlines useCase;
  StreamSubscription<ArticlesState>? _subscription;

  ArticlesCubit({required this.useCase}) : super(const ArticlesState.initial());

  void sync() async {
    emit(const ArticlesState.loading());
    await useCase.sync().when(
          success: (_) => doNothing(
            because: "On this case we'll receive items on the subscription",
          ),
          failure: (failure) =>
              emit(ArticlesState.error(error: failure.message)),
        );
  }

  void init() {
    _subscription = useCase
        .topHeadlines()
        .map(
          (data) => data
              .take(10)
              .map((article) => TopHeadlineViewState.from(article: article))
              .toList(),
        )
        .map((viewState) => ArticlesState.loaded(viewState: viewState))
        .listen(emit);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
