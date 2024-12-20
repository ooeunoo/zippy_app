import 'package:zippy/data/entity/article.entity.dart';
import 'package:zippy/domain/model/top_articles_by_content_type.model.dart';

class TopArticlesByContentTypeEntity {
  final int content_type_id;
  final String content_type_name;
  final List<ArticleEntity> articles;

  TopArticlesByContentTypeEntity({
    required this.content_type_id,
    required this.content_type_name,
    required this.articles,
  });

  factory TopArticlesByContentTypeEntity.fromJson(Map<String, dynamic> json) {
    return TopArticlesByContentTypeEntity(
      content_type_id: json['content_type_id'],
      content_type_name: json['content_type_name'],
      articles: (json['articles'] as List)
          .map((i) => ArticleEntity.fromJson(i))
          .toList(),
    );
  }

  TopArticlesByContentType toModel() {
    return TopArticlesByContentType(
      contentTypeId: content_type_id,
      contentTypeName: content_type_name,
      articles: articles.map((e) => e.toModel()).toList(),
    );
  }
}
