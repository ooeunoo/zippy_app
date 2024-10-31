import 'dart:async';

import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/article.entity.dart';
import 'package:zippy/data/entity/user_article_highlight.entity.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/params/create_user_article.params.dart';
import 'package:zippy/domain/model/params/get_aritlces.params.dart';
import 'package:zippy/domain/model/user_article_highlight.model.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';

String TABLE = 'user_article_highlights';

abstract class UserArticleHighlightDatasource {
  Future<Either<Failure, List<UserArticleHighlight>>>
      getAllUserArticleHighlights(String userId);
  Future<Either<Failure, UserArticleHighlight>> getUserArticleHighlight(
      String userId, int articleId);
  Future<Either<Failure, bool>> createUserArticleHighlight(
      CreateUserArticleHighlightParams params);
  // Future<Either<Failure, void>> updateUserArticleHighlight(
  //     UserArticleHighlight userArticleHighlight);
  // Future<Either<Failure, void>> deleteUserArticleHighlight(int id);
}

class UserArticleHighlightDatasourceImpl
    implements UserArticleHighlightDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, List<UserArticleHighlight>>>
      getAllUserArticleHighlights(String userId) async {
    try {
      List<Map<String, dynamic>> response = await provider.client
              .from(TABLE)
              .select('*')
              .eq('user_id', userId)
              .order('created_at')
          // .order('images', nullsFirst: false)
          ;

      List<UserArticleHighlight> result = response
          .map((r) => UserArticleHighlightEntity.fromJson(r).toModel())
          .toList();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserArticleHighlight>> getUserArticleHighlight(
      String userId, int articleId) async {
    try {
      Map<String, dynamic> response = await provider.client
          .from(TABLE)
          .select('*')
          .eq('user_id', userId)
          .eq('article_id', articleId)
          .single();

      UserArticleHighlight result =
          UserArticleHighlightEntity.fromJson(response).toModel();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> createUserArticleHighlight(
      CreateUserArticleHighlightParams params) async {
    try {
      await provider.client.from(TABLE).insert(params.toJson());
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
