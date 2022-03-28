import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

abstract class InternalFailure {
  final String message = "";
}

@freezed
class ServerFailure with _$ServerFailure implements InternalFailure {
  const factory ServerFailure({required String message}) = _ServerFailure;
}

@freezed
class CacheFailure with _$CacheFailure implements InternalFailure {
  const factory CacheFailure({required String message}) = _CacheFailure;
}
