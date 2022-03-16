import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable implements Exception {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class Success<S> extends Equatable {
  final S data;
  const Success({required this.data});

  @override
  List<S> get props => [data];
}

class Result<S> extends Equatable {
  final Failure? _failure;
  final S? _data;

  const Result(this._data, this._failure);

  factory Result.failure(Failure failure) => Result(null, failure);
  factory Result.success(S data) => Result(data, null);

  Failure get failure {
    assert(_failure != null);
    return _failure!;
  }

  S get data {
    assert(_data != null);
    return _data!;
  }

  bool get isSuccess => _failure == null;
  bool get isFailure => _failure != null;

  @override
  List<Object?> get props => [_failure, _data];
}
