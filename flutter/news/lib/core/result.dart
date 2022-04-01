import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news/core/error/failures.dart';

part 'result.freezed.dart';

@freezed
class Result<S> with _$Result<S> {
  const factory Result.success({required S data}) = _Success<S>;
  const factory Result.failure({required InternalFailure failure}) = _Failure;
  factory Result.completed() => Result.success(data: (() {})()) as _Success<S>;
}

extension AsSuccess<T> on T {
  Result<T> asSuccess() => Result<T>.success(data: this);
}

extension AsFailure on InternalFailure {
  Result<T> asFailure<T>() => Result<T>.failure(failure: this);
}
