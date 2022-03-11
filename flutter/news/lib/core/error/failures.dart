

abstract class Failure {
  const Failure([dynamic message]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class ServerFailure extends Failure {
  final String message;

  const ServerFailure(this.message);
}

class CacheFailure extends Failure {
  final String message;

  const CacheFailure(this.message);
}
