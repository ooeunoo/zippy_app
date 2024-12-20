import 'dart:async';

import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/article.entity.dart';
import 'package:zippy/data/entity/get_top_article_by_content_type.entity.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/params/get_articles_by_keyword.params.dart';
import 'package:zippy/domain/model/params/get_random_articles.params.dart';
import 'package:zippy/domain/model/params/get_recommend_aritlces.params.dart';
import 'package:zippy/domain/model/params/get_search_articles.params.dart';
import 'package:zippy/domain/model/params/get_top_articles_by_content_type.params.dart';
import 'package:zippy/domain/model/top_articles_by_content_type.model.dart';

String TABLE = 'articles';

enum RPC {
  getRecommendedArticles('get_recommended_articles'),
  getSearchArticles('get_search_articles'),
  getRandomArticles('get_random_articles'),
  getTopArticlesByContentType('get_top_articles_by_content_type');

  final String function;

  const RPC(this.function);
}

abstract class ArticleDatasource {
  Future<Either<Failure, List<Article>>> getRecommendedArticles(
      GetRecommendedArticlesParams params);
  Future<Either<Failure, List<Article>>> getSearchArticles(
      GetSearchArticlesParams params);
  Future<Either<Failure, Article>> getArticle(int id);
  Future<Either<Failure, List<Article>>> getArticlesByKeyword(
      GetArticlesByKeywordParams params);

  Future<Either<Failure, List<Article>>> getRandomArticles(
      GetRandomArticlesParams params);
  Future<Either<Failure, List<TopArticlesByContentType>>>
      getTopArticlesByContentType(GetTopArticlesByContentTypeParams params);
}

class ArticleDatasourceImpl implements ArticleDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, List<Article>>> getRecommendedArticles(
      GetRecommendedArticlesParams params) async {
    try {
      var response = await provider.client
          .rpc(RPC.getRecommendedArticles.function, params: params.toJson());
      List<Article> result = [];
      for (var r in (response as List)) {
        try {
          if (r['link'].startsWith('https://www.youtube.com/')) {
            continue;
          }
          result.add(ArticleEntity.fromJson(r).toModel());
        } catch (e, stackTrace) {
          // TODO: 올바르지않은 형태의 데이터가 들어있는경우, 로깅 필요!!
          print('Error:$e \n stackTrace:$stackTrace');
          continue;
        }
      }

      return Right(result);
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getSearchArticles(
      GetSearchArticlesParams params) async {
    try {
      var response = await provider.client
          .rpc(RPC.getSearchArticles.function, params: params.toJson());

      List<Article> result = [];
      for (var r in (response as List)) {
        try {
          if (r['link'].startsWith('https://www.youtube.com/')) {
            continue;
          }
          result.add(ArticleEntity.fromJson(r).toModel());
        } catch (e, stackTrace) {
          print('Error:$e \n stackTrace:$stackTrace');
          continue;
        }
      }

      return Right(result);
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
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
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
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
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getRandomArticles(
      GetRandomArticlesParams params) async {
    try {
      var response = await provider.client
          .rpc(RPC.getRandomArticles.function, params: params.toJson());

      List<Article> result = [];
      for (var r in (response as List)) {
        try {
          if (r['link'].startsWith('https://www.youtube.com/')) {
            continue;
          }
          result.add(ArticleEntity.fromJson(r).toModel());
        } catch (e, stackTrace) {
          print('Error:$e \n stackTrace:$stackTrace');
          continue;
        }
      }

      return Right(result);
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<TopArticlesByContentType>>>
      getTopArticlesByContentType(
          GetTopArticlesByContentTypeParams params) async {
    try {
      var response = await provider.client.rpc(
          RPC.getTopArticlesByContentType.function,
          params: params.toJson());

      List<TopArticlesByContentType> result = [];
      for (var r in (response as List)) {
        result.add(TopArticlesByContentTypeEntity.fromJson(r).toModel());
      }

      return Right(result);
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }
}
