import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:news/features/frontpage/data/models/article_model.dart';
import 'package:news/features/frontpage/data/models/base_news_response_model.dart';
import 'package:news/features/frontpage/data/models/source_model.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  final tArticle = ArticleModel(
      source: SourceModel(id: null, name: "Lifehacker.com"),
      author: "Jeff Somers",
      title: "Is the Crypto Bubble Going to Burst?",
      description: "Even if you aren’t paying attention to Bitcoin",
      url:
          "https://lifehacker.com/is-the-crypto-bubble-going-to-burst-1848475768",
      urlToImage:
          "https://i.kinja-img.com/gawker-media/image/upload/c_fill,f_auto,fl_progressive,g_center,h_675,pg_1,q_80,w_1200/976a59b09e0e681e692bd7517498e3f2.jpg",
      publishedAt: "2022-02-09T16:00:00Z",
      content: "Even if you arent paying attention to Bitcoin");

  final tResponse = BaseNewsResponseModel(
      status: "ok", totalResults: 1, articles: [tArticle]);

  test(
    'should be subclass of Articles entity',
    () async {
      //assert
      expect(tArticle, isA<Article>());
    },
  );

  group("fromJson", () {
    test(
      'should return list valid model',
      () async {
        final Map<String, dynamic> jsonMap =
            json.decode(fixture("articles.json"));

        final result = BaseNewsResponseModel.fromJson(jsonMap);

        expect(result, equals(tResponse));
      },
    );
  });

  group("toJson", () {
    test(
      'should return JSON map containing the data',
      () async {
        final result = tResponse.toJson();

        final expectedMap = {
          "status": "ok",
          "totalResults": 1,
          "articles": [
            {
              "source": {"id": null, "name": "Lifehacker.com"},
              "author": "Jeff Somers",
              "title": "Is the Crypto Bubble Going to Burst?",
              "description": "Even if you aren’t paying attention to Bitcoin",
              "url":
                  "https://lifehacker.com/is-the-crypto-bubble-going-to-burst-1848475768",
              "urlToImage":
                  "https://i.kinja-img.com/gawker-media/image/upload/c_fill,f_auto,fl_progressive,g_center,h_675,pg_1,q_80,w_1200/976a59b09e0e681e692bd7517498e3f2.jpg",
              "publishedAt": "2022-02-09T16:00:00Z",
              "content": "Even if you arent paying attention to Bitcoin"
            }
          ]
        };

        expect(result, expectedMap);
      },
    );
  });
}
