import 'package:news/features/frontpage/data/models/article_model.dart';

abstract class ArticlesLocalDataSource {
  Future<List<ArticleModel>> getLastTopHeadlines();
  Future<void> cacheTopHeadlines(List<ArticleModel> topHeadlinesList);
}