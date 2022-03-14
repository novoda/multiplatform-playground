import 'package:news/core/result.dart';

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheFailure && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}
