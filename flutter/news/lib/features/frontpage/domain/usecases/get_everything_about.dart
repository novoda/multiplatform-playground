import 'package:dartz/dartz.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/core/usecases/usecase.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';
import 'package:news/features/frontpage/domain/usecases/get_top_headlines.dart';

import '../../data/repositories/articles_repository.dart';

class GetEverythingAbout implements UseCase<List<Article>, Params> {
  final ArticlesRepository repository;

  GetEverythingAbout(this.repository);

  @override
  Future<Either<Failure, List<Article>>> call(Params params) async {
    return await repository.getEverythingAbout(params.query);
  }
}
