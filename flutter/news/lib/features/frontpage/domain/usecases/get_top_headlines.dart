import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';

import '../../../../core/usecases/usecase.dart';

class GetTopHeadlines implements UseCase<Result<List<Article>>, NoParams> {
  final ArticlesRepository repository;

  GetTopHeadlines(this.repository);

  @override
  Future<Result<List<Article>>> call(NoParams noParams) async {
    return await repository.topHeadlines();
  }
}

class Params {
  final String query;

  const Params({required this.query});
}
