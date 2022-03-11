import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/models/article_model.dart';

abstract class ArticlesLocalDataSource {
  Future<Result<List<ArticleModel>>> topHadLines();
  Future<void> save({List<ArticleModel> topHeadlines});
}
