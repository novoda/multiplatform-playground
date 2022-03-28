import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:news/core/language_extensions.dart';
import 'package:news/features/frontpage/domain/usecases/get_top_headlines.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_state.dart';
import 'package:rxdart/rxdart.dart';

enum ActionStatus { idle, loading, error }

class ArticlesCubit extends Cubit<ArticlesState> {
  final GetTopHeadlines _useCase;
  late final StreamSubscription<ArticlesState> _subscription;
  final BehaviorSubject<ActionStatus> _status = BehaviorSubject()
    ..add(ActionStatus.idle);

  ArticlesCubit(this._useCase) : super(const ArticlesState.initial());

  void sync() async {
    _status.add(ActionStatus.loading);
    await _useCase.sync().when(
          success: (_) => _status.add(ActionStatus.idle),
          failure: (failure) => _status.add(ActionStatus.error),
        );
  }

  void init() {
    _subscription = Rx.combineLatest2(
      _useCase.topHeadlines(),
      _status.stream,
      ArticlesState.from,
    ).listen(emit);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
