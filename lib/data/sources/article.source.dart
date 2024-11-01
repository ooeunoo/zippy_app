import 'dart:async';

import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/article.entity.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/params/get_aritlces.params.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';

String TABLE = 'articles';

abstract class ArticleDatasource {
  Future<Either<Failure, List<Article>>> getArticles(GetArticlesParams params);
  Future<Either<Failure, Article>> getArticle(int id);
  Stream<List<Article>> subscribeArticles(List<UserSubscription> subscriptions);
  Future<void> upArticleViewCount(int id);
  Future<void> upArticleReportCount(int id);
}

enum RPC {
  increaseViewCount('increase_view_count_of_content'),
  increaseReportCount('increase_report_count_of_content');

  const RPC(this.function);
  final String function;
}

class ArticleDatasourceImpl implements ArticleDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, List<Article>>> getArticles(
      GetArticlesParams params) async {
    try {
      // content_img_url이 있는것 > view_count가 높은것 > 시간순
      List<Map<String, dynamic>> response = await provider.client
              .from(TABLE)
              .select('*')
              // .inFilter('source_id', params.subscriptionTypes)
              .limit(params.limit)
              .order('view_count', ascending: false)
              .order('created_at')
          // .order('images', nullsFirst: false)
          ;

      List<Article> result =
          response.map((r) => ArticleEntity.fromJson(r).toModel()).toList();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Article>> getArticle(int id) async {
    try {
      Map<String, dynamic> response =
          await provider.client.from(TABLE).select('*').eq('id', id).single();

      Article result = ArticleEntity.fromJson(response).toModel();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Stream<List<Article>> subscribeArticles(
      List<UserSubscription> subscriptions) {
    List<int> sourceIds = [];
    for (UserSubscription subscription in subscriptions) {
      // sourceIds.add(subscription.type);
    }
    return provider.client
        .from(TABLE)
        .stream(primaryKey: ['id'])
        .inFilter('source_id', sourceIds)
        .order('created_at', ascending: false)
        .limit(1000)
        .map((data) => data.map((item) {
              return ArticleEntity.fromJson(item).toModel();
            }).toList());
  }

  @override
  Future<void> upArticleViewCount(int id) {
    return provider.client
        .rpc(RPC.increaseViewCount.function, params: {'content_id': id});
  }

  @override
  Future<void> upArticleReportCount(int id) {
    return provider.client
        .rpc(RPC.increaseReportCount.function, params: {'content_id': id});
  }
}
