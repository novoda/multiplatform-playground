import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';

class GetTopHeadlines {
  final ArticlesRepository repository;

  GetTopHeadlines(this.repository);

  Future<Result<List<Article>>> topHeadlines() async {
    return await repository.topHeadlines();
  }
}
