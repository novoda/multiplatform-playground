import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_viewstate.dart';
import 'package:news/features/frontpage/presentation/widgets/news_card.dart';

class HorizontalListTopHeadlines extends StatelessWidget {
  const HorizontalListTopHeadlines({Key? key, required this.topHeadlines})
      : super(key: key);

  final List<TopHeadlineViewState> topHeadlines;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                top: 16.0,
                bottom: 8.0,
              ),
              child: Text(
                'TOP HEADLINES',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.scale,
            ),
            items: topHeadlines
                .map((headline) => ArticleCard(article: headline))
                .toList(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                top: 8.0,
                bottom: 8.0,
                right: 16.0,
              ),
              child: TextButton(
                onPressed: () {
                  //TODO: implement new widget full top Headlines vertical list
                },
                child: Text(
                  'VIEW ALL',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}
