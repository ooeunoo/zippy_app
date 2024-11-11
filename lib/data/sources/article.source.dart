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
}

class ArticleDatasourceImpl implements ArticleDatasource {
  SupabaseProvider provider = Get.find();

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
