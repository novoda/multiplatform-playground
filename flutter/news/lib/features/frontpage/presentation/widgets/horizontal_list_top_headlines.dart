import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_viewstate.dart';

class HorizontalListTopHeadlines extends StatelessWidget {
  const HorizontalListTopHeadlines({Key? key, required this.topHeadlines})
      : super(key: key);

  final List<TopHeadlineViewState> topHeadlines;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CarouselSlider.builder(
          options: CarouselOptions(
            height: 200.0,
            enlargeCenterPage: false,
            viewportFraction: 1,
          ),
          itemCount: (topHeadlines.length / 2).round(),
          itemBuilder: (context, index, _) => Row(
            children: topHeadlines
                .getRange(index * 2, min(index * 2 + 2, topHeadlines.length))
                .map(
                  (headline) => Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(headline.title),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
}
