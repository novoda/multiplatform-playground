import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/features/frontpage/presentation/bloc/articles_cubit.dart';
import 'package:news/features/frontpage/presentation/widgets/loading_widget.dart';

import '../../../../dependencies_injection.dart';
import '../widgets/horizontal_list_top_headlines.dart';

class FrontPage extends StatelessWidget {
  const FrontPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your News"),
      ),
      body: BlocProvider<ArticlesCubit>(
        create: (context) => getIt<ArticlesCubit>(),
        child: BlocBuilder<ArticlesCubit, ArticlesState>(
          builder: (context, state) {
            if (state is TopHeadlinesLoaded) {
              return HorizontalListTopHeadlines(
                  topHeadlines: state.topHeadlines);
            } else if (state is TopHeadlinesLoading) {
              return const LoadingWidget();
            } else if (state is TopHeadlinesError) {
              return Text(state.error ?? "Unknown error");
            } else {
              context.read<ArticlesCubit>().getTopHeadlines();
              return const LoadingWidget();
            }
          },
        ),
      ),
    );
  }
}
