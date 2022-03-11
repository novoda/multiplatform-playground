import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/models/article_model.dart';

abstract class ArticlesRemoteDataSource {
  Future<Result<List<ArticleModel>>> getTopHeadlines();
  Future<Result<List<ArticleModel>>> getEverythingAbout(String query);
}
