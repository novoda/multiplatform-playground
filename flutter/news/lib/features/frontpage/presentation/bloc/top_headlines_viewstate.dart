import 'package:equatable/equatable.dart';

class TopHeadlineViewState extends Equatable {
  final String title;
  final String url;
  final String imageUrl;

  const TopHeadlineViewState(this.title, this.url, this.imageUrl);

  @override
  List<Object?> get props => [title, url, imageUrl];
}
