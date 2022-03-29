import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news/core/language_extensions.dart';
import 'package:news/features/frontpage/domain/usecases/get_top_headlines.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_state.dart';
import 'package:rxdart/rxdart.dart';

part 'articles_cubit.freezed.dart';

class ArticlesCubit extends Cubit<ArticlesState> {
  final GetTopHeadlines useCase;
  late final StreamSubscription<ArticlesState> _subscription;
  final BehaviorSubject<CommandStatus> _status = BehaviorSubject()
    ..add(const CommandStatus.idle());

  ArticlesCubit({required this.useCase}) : super(const ArticlesState.initial());

  void sync() async {
    _status.add(const CommandStatus.loading());
    await useCase.sync().when(
          success: (_) => _status.add(const CommandStatus.idle()),
          failure: (failure) =>
              _status.add(CommandStatus.error(message: failure.message)),
        );
  }

  void init() {
    _subscription = Rx.combineLatest2(
      useCase.topHeadlines(),
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

@freezed
class CommandStatus with _$CommandStatus {
  const factory CommandStatus.idle() = _Initial;
  const factory CommandStatus.loading() = _Loading;
  const factory CommandStatus.error({required String message}) = _Error;
}
