import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_viewstate.dart';
import 'package:news/features/frontpage/presentation/widgets/news_card.dart';

import '../core/utils/extensions.dart';

void main() {
  final article = TopHeadlineViewState.from(
    article: Stub.article(
      title: "1",
    ),
  );

  testWidgets(
      'GIVEN ArticleCard widget is called'
      'WHEN loading article'
      'THEN shows correct title and description', (WidgetTester tester) async {
    mockNetworkImagesFor(() async {
      // Build our app and trigger a frame.

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ArticleCard(article: article),
          ),
        ),
      );
      expect(find.text('1'), findsOneWidget);
    });
  });
}
