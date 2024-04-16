import 'dart:math';

import 'package:cocomu/app/enum/community.dart';
import 'package:cocomu/data/providers/dcinside/dcinside.dart';
import 'package:cocomu/data/providers/dcinside/dcinside_category.dart';
import 'package:cocomu/domain/entities/article_entity.dart';
import 'package:cocomu/domain/repositories/community_repository.dart';

class CommunityRepositoryIml extends CommunityRepository {
  DcinsideAPI dcinsideAPI;

  CommunityRepositoryIml(this.dcinsideAPI);

  @override
  Future<ArticleEntity> getArticle(
      Community community, String category, int page) async {
    switch (community) {
      case Community.dcinside:
        return dcinsideAPI.getArticle(category, page);
      case Community.ppomppu:
      case Community.bobaedream:
        return dcinsideAPI.getArticle(category, page);
      // TODO: Handle this case.
    }
  }
}
