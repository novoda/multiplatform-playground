import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const<dynamic>[]]);

  @override
  List<Object> get props => const [];
}

class ServerFailure extends Failure {
  final String message;

  const ServerFailure(this.message);
}

class CacheFailure extends Failure {
  final String message;

  const CacheFailure(this.message);
}