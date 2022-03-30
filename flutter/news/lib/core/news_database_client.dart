import 'package:news/features/frontpage/domain/entities/article.dart';

abstract class DB<T> {
  Future<void> save(T data);
  Future<T> read();
}

class ArticlesDummyDB implements DB<List<Article>> {
  List<Article> data = [];

  @override
  Future<void> save(List<Article> articles) async {
    data.clear();
    data.addAll(articles);
  }

  @override
  Future<List<Article>> read() async => data;
}
