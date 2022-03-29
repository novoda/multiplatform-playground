import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';

class GetTopHeadlines {
  final ArticlesRepository repository;

  GetTopHeadlines({required this.repository});

  Stream<List<Article>> topHeadlines() => repository.topHeadlines();

  Future<Result<void>> sync() => repository.sync();
}
