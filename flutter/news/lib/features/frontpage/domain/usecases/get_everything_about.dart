import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';

class GetEverythingAbout {
  final ArticlesRepository repository;

  GetEverythingAbout(this.repository);

  Future<Result<List<Article>>> everythingAbout(String query) async {
    return await repository.everythingAbout(query);
  }
}
