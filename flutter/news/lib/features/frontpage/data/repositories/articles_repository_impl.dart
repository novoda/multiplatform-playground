import 'package:dartz/dartz.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';
import 'package:news/features/frontpage/domain/repositories/articles_repository.dart';

class ArticlesRepositoryImpl implements ArticlesRepository {
  @override
  Future<Either<Failure, List<Article>>> getEverythingAbout(String query) {
    // TODO: implement getEverythingAbout
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Article>>> getTopHeadlines() {
    // TODO: implement getTopHeadlines
    throw UnimplementedError();
  }

}