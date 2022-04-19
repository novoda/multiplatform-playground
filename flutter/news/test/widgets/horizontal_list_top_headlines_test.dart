import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_viewstate.dart';
import 'package:news/features/frontpage/presentation/widgets/horizontal_list_top_headlines.dart';
import 'package:news/features/frontpage/presentation/widgets/news_card.dart';

import '../core/utils/extensions.dart';

void main() {
  final topHeadlines =
      List.generate(10, (index) => Stub.article(title: "$index"))
          .map((e) => TopHeadlineViewState.from(article: e))
          .toList();

  testWidgets(
      'GIVEN HorizontalListTopHeadlines widget is called'
      'WHEN loading articles'
      'THEN shows 3 VISIBLE articles', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalListTopHeadlines(
              topHeadlines: topHeadlines,
            ),
          ),
        ),
      );

      expect(find.byType(ArticleCard), findsNWidgets(3));
      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('9'), findsOneWidget);
    });
  });
}
