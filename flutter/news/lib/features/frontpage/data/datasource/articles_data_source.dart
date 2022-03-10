import 'package:news/features/frontpage/data/models/article_model.dart';

abstract class ArticlesRemoteDataSource {
  Future<List<ArticleModel>> getTopHeadlines();
  Future<List<ArticleModel>> getEverythingAbout(String query);
}
