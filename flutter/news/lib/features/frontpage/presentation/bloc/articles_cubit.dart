import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/core/language_extensions.dart';
import 'package:news/features/frontpage/domain/usecases/get_top_headlines.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_state.dart';
import 'package:rxdart/rxdart.dart';

class ArticlesCubit extends Cubit<ArticlesState> {
  final GetTopHeadlines _useCase;
  late final StreamSubscription<ArticlesState> _subscription;
  final BehaviorSubject<bool> _isLoading = BehaviorSubject()..add(false);
  final BehaviorSubject<InternalFailure?> _error = BehaviorSubject()..add(null);

  ArticlesCubit(this._useCase) : super(const ArticlesState.initial());

  //command
  void sync() async {
    _isLoading.add(true);
    await _useCase
        .sync()
        .when(
          success: (_) => _error.add(null),
          failure: (failure) => _error.add(failure),
        )
        .whenComplete(() => _isLoading.add(false));
  }

  //query
  void init() {
    _subscription = Rx.combineLatest3(
      _useCase.topHeadlines(),
      _isLoading.stream,
      _error.stream,
      ArticlesState.from,
    ).listen(emit);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
