import 'package:dartz/dartz.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';

abstract class ArticlesRepository {
  Future<Either<Failure, List<Article>>> getTopHeadlines();
  Future<Either<Failure, List<Article>>> getEverythingAbout(String query);
}
