import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

abstract class InternalFailure {
  final String message;

  InternalFailure(this.message);
}

@freezed
abstract class ServerFailure extends InternalFailure with _$ServerFailure {
  const factory ServerFailure({required String message}) = _ServerFailure;
}

@freezed
abstract class CacheFailure extends InternalFailure with _$CacheFailure {
  const factory CacheFailure({required String message}) = _CacheFailure;
}
