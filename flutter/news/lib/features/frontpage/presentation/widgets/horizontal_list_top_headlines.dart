import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_viewstate.dart';
import 'package:news/features/frontpage/presentation/widgets/news_card.dart';

class HorizontalListTopHeadlines extends StatelessWidget {
  const HorizontalListTopHeadlines({Key? key, required this.topHeadlines})
      : super(key: key);

  final List<TopHeadlineViewState> topHeadlines;

  @override
  Widget build(BuildContext context) => CarouselSlider(
        options: CarouselOptions(
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.scale,
        ),
        items: topHeadlines
            .map((headline) => ArticleCard(article: headline))
            .toList(),
      );
}
