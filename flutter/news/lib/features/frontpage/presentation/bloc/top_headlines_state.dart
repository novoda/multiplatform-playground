part of 'articles_cubit.dart';

abstract class ArticlesState extends Equatable {
  const ArticlesState();
}

class TopHeadlinesInitial extends ArticlesState {
  @override
  List<Object> get props => [];
}

class TopHeadlinesLoading extends ArticlesState {
  @override
  List<Object> get props => [];
}

class TopHeadlinesLoaded extends ArticlesState {
  final List<TopHeadlineViewState> topHeadlines;

  const TopHeadlinesLoaded(this.topHeadlines);

  @override
  List<Object> get props => [topHeadlines];
}

class TopHeadlinesError extends ArticlesState {
  final String? error;

  const TopHeadlinesError(this.error);

  @override
  List<Object?> get props => [error];
}
