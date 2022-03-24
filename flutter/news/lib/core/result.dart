import 'package:freezed_annotation/freezed_annotation.dart';

import 'error/failures.dart';
part 'result.freezed.dart';

@freezed
class Result<S> with _$Result<S> {
  const factory Result.success({required S data}) = _Success<S>;
  const factory Result.failure({required InternalFailure failure}) = _Failure;
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
