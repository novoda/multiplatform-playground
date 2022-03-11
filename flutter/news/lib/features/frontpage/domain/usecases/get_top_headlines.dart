import 'package:dartz/dartz.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';

import '../../../../core/usecases/usecase.dart';

class GetTopHeadlines implements UseCase<List<Article>, NoParams> {
  final ArticlesRepository repository;

  GetTopHeadlines(this.repository);

  @override
  Future<Either<Failure, List<Article>>> call(NoParams noParams) async {
    return await repository.getTopHeadlines();
  }
}

class Params {
  final String query;

  const Params({required this.query});
}
