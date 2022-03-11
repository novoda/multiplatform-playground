import 'package:news/core/result.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';

import '../../data/repositories/articles_repository.dart';

class GetEverythingAbout {
  final ArticlesRepository repository;

  GetEverythingAbout(this.repository);

  Future<Result<List<Article>>> everythingAbout(String query) async {
    return await repository.everythingAbout(query);
  }
}
