import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';

class GetTopHeadlines {
  final ArticlesRepository _repository;

  GetTopHeadlines(this._repository);

  Stream<List<Article>> topHeadlines() => _repository.topHeadlines();

  Future<Result<void>> sync() => _repository.sync();
}
