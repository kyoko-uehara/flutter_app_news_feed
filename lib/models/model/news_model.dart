import 'package:json_annotation/json_annotation.dart';

part 'news_model.g.dart';

@JsonSerializable()
class News {
  final List<Article> article;
  News(this.article);

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);
  Map<String, dynamic> toJson() => _$NewsToJson(this);
}

@JsonSerializable()
class Article {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  @JsonKey(name:"publishedAt") final String publishedDate;
  final String content;

  Article({
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedDate,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}