import 'package:cocomu/app/enum/community.dart';
import 'package:cocomu/data/providers/dcinside/dcinside_category.dart';
import 'package:cocomu/domain/entities/article_entity.dart';

abstract class CommunityRepository {
  Future<ArticleEntity> getArticle(
      Community community, String category, int page);
}
