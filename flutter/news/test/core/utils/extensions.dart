import 'package:news/features/frontpage/domain/entities/article.dart';
import 'package:news/features/frontpage/domain/entities/source.dart';

class Stub {
  static Article article({
    String title = "",
    String url = "",
    String imageUrl = "",
  }) =>
      Article(
        source: const Source(id: null, name: ""),
        author: "",
        title: title,
        description: "",
        url: url,
        urlToImage: imageUrl,
        publishedAt: "",
        content: "",
      );
}
