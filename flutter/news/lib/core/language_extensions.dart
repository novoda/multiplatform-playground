import 'dart:async';

import 'package:news/core/error/failures.dart';
import 'package:news/core/result.dart';

void doNothing({required String because}) => {};

extension FutureExtension<T> on Future<Result<T>> {
  Future<R> when<R>({
    required FutureOr<R> Function(T value) success,
    required FutureOr<R> Function(InternalFailure failure) failure,
    Function? onError,
  }) =>
      then(
        (value) => value.when(
          success: (data) => success(data),
          failure: (theFailure) => failure(theFailure),
        ),
      );
}
