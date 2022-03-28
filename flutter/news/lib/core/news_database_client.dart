import 'package:news/features/frontpage/domain/entities/article.dart';

abstract class DB {
  Future<void> save(List<Article> articles);
  Future<List<Article>> read();
}

class DummyDB implements DB {
  List<Article> articles = [];

  @override
  Future<void> save(List<Article> articles) async {
    this.articles.clear();
    this.articles.addAll(articles);
  }

  @override
  Future<List<Article>> read() async => articles;
}
