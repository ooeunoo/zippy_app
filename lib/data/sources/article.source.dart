import 'dart:async';

import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/article.entity.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/params/get_aritlces.params.dart';
import 'package:zippy/domain/model/params/get_articles_by_keyword.params.dart';

String TABLE = 'articles';

abstract class ArticleDatasource {
  Future<Either<Failure, List<Article>>> getArticles(GetArticlesParams params);
  Future<Either<Failure, Article>> getArticle(int id);
  Future<Either<Failure, List<Article>>> getArticlesByKeyword(
      GetArticlesByKeywordParams params);
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
      List<Map<String, dynamic>> response = await provider.client
          .from(TABLE)
          .select('*, sources(*)')
          .limit(params.limit)
          .order('created_at');

      List<Article> result =
          response.map((r) => ArticleEntity.fromJson(r).toModel()).toList();

      print(result.length);
      return Right(result);
    } catch (e) {
      print(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getArticlesByKeyword(
      GetArticlesByKeywordParams params) async {
    try {
      List<Map<String, dynamic>> response = await provider.client
          .from(TABLE)
          .select('*, sources(*)')
          .contains('keywords', [params.keyword])
          .limit(params.limit)
          .order('published', ascending: false); // 최신순

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
      Map<String, dynamic> response = await provider.client
          .from(TABLE)
          .select('*, sources(*)')
          .eq('id', id)
          .single();

      Article result = ArticleEntity.fromJson(response).toModel();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
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
