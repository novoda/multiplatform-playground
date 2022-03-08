import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../features/frontpage/domain/entities/article.dart';
import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, List<Article>>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
