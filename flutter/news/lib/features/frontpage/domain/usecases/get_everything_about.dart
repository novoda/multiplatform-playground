import 'package:news/core/result.dart';
import 'package:news/core/usecases/usecase.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';
import 'package:news/features/frontpage/domain/usecases/get_top_headlines.dart';

import '../../data/repositories/articles_repository.dart';

class GetEverythingAbout implements UseCase<Result<List<Article>>, Params> {
  final ArticlesRepository repository;

  GetEverythingAbout(this.repository);

  @override
  Future<Result<List<Article>>> call(Params params) async {
    return await repository.getEverythingAbout(params.query);
  }
}
