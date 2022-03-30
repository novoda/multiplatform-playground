import 'package:flutter_test/flutter_test.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_viewstate.dart';

import '../../../../core/utils/extensions.dart';

void main() {
  var article = Stub.article(
    title: "news title",
    imageUrl: "news image url",
    url: "news url",
  );

  test(
    'GIVEN an article WHEN converting to view state THEN it is correctly converted',
    () {
      var viewState = TopHeadlineViewState.from(article: article);
      expect(
        viewState,
        const TopHeadlineViewState(
          title: "news title",
          imageUrl: "news image url",
          url: "news url",
        ),
      );
    },
  );
}
