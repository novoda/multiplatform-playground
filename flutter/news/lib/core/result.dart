import 'package:freezed_annotation/freezed_annotation.dart';

import 'error/failures.dart';
part 'result.freezed.dart';

@freezed
class Result<S> with _$Result {
  const Result._();
  const factory Result.failure({required InternalFailure failure}) = Failure;
  const factory Result.success({required S data}) = Success<S>;
}

extension AsSuccess<T> on T {
  Result<T> asSuccess() {
    return Result<T>.success(data: this);
  }
}

extension AsFailure on InternalFailure {
  Result<T> asFailure<T>() {
    return Result<T>.failure(failure: this);
  }
}

extension ResultExtensions<S> on Result<S> {
  fold({
    required Function(S) ifSuccess,
    required Function(InternalFailure) ifFailure,
  }) {
    if (this is Success<S>) {
      ifSuccess((this as Success).data);
    } else {
      ifFailure((this as Failure).failure);
    }
  }

  onSuccess(Function onSuccess) {
    if (this is Success<S>) {
      onSuccess(this as Success<S>);
    }
    return this;
  }

  onFailure(Function onFailure) {
    if (this is Failure) {
      onFailure(this as Failure);
    }
    return this;
  }
}
