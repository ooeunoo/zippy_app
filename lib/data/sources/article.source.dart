import 'dart:async';

import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/article.entity.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/params/get_aritlces.params.dart';
import 'package:zippy/domain/model/params/get_articles_by_keyword.params.dart';
import 'package:zippy/domain/model/params/get_recommend_aritlces.params.dart';

String TABLE = 'articles';

// CREATE OR REPLACE FUNCTION get_recommended_articles(
//     user_id UUID DEFAULT NULL,            -- 사용자 ID (NULL인 경우 익명 사용자)
//     time_range INTERVAL DEFAULT '7 days'::INTERVAL,  -- 기사 검색 시간 범위 (기본값: 7일)
//     exclude_viewed BOOLEAN DEFAULT true,   -- 이미 본 기사 제외 여부
//     min_published_at TIMESTAMP WITH TIME ZONE DEFAULT NULL,  -- 최소 발행 시간
//     max_published_at TIMESTAMP WITH TIME ZONE DEFAULT NULL,  -- 최대 발행 시간
//     limit_count INTEGER DEFAULT 20         -- 반환할 기사 수
// )
enum RPC {
  getRecommendedArticles('get_recommended_articles'),
  ;

  final String function;

  const RPC(this.function);
}

abstract class ArticleDatasource {
  Future<Either<Failure, List<Article>>> getRecommendedArticles(
      GetRecommendedArticlesParams params);
  Future<Either<Failure, List<Article>>> getArticles(GetArticlesParams params);
  Future<Either<Failure, Article>> getArticle(int id);
  Future<Either<Failure, List<Article>>> getArticlesByKeyword(
      GetArticlesByKeywordParams params);
}

class ArticleDatasourceImpl implements ArticleDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, List<Article>>> getRecommendedArticles(
      GetRecommendedArticlesParams params) async {
    try {
      var response = await provider.client
          .rpc(RPC.getRecommendedArticles.function, params: params.toJson());

      List<Article> result = (response as List)
          .map((r) => ArticleEntity.fromJson(r).toModel())
          .toList();

      return Right(result);
    } catch (e) {
      print(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getArticles(
      GetArticlesParams params) async {
    try {
      var query = provider.client.from(TABLE).select('*, sources(*)');

      // search 파라미터가 있을 경우에만 textSearch 조건 추가
      if (params.search != null && params.search!.isNotEmpty) {
        query = query.textSearch('title', params.search!);
      }

      final response =
          await query.limit(params.limit).order('published', ascending: false);

      List<Article> result =
          response.map((r) => ArticleEntity.fromJson(r).toModel()).toList();

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
}
