import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:zippy/data/entity/article_comment.entity.dart';
import 'package:zippy/domain/model/article_comment.model.dart';
import 'package:zippy/domain/model/params/create_article_comment.params.dart';

const String TABLE = 'article_comments';

enum RPC {
  GET_ARTICLE_COMMENTS('get_article_comments'),
  ;

  final String function;

  const RPC(this.function);
}

abstract class ArticleCommentDatasource {
  Future<Either<Failure, List<ArticleComment>>> getComments(int articleId);
  Future<Either<Failure, ArticleComment>> createComment(
      CreateArticleCommentParams params);
}

class ArticleCommentDatasourceImpl implements ArticleCommentDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, List<ArticleComment>>> getComments(
      int articleId) async {
    try {
      // 계층형 구조로 댓글 조회
      final response = await provider.client.rpc(
          RPC.GET_ARTICLE_COMMENTS.function,
          params: {'p_article_id': articleId});

      List<ArticleComment> comments = (response as List)
          .map((json) => ArticleCommentEntity.fromJson(json).toModel())
          .toList();

      return Right(comments);
    } catch (e, stackTrace) {
      print('Caught an exception: $e');
      print('Stack Trace: $stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ArticleComment>> createComment(
      CreateArticleCommentParams params) async {
    try {
      final response = await provider.client
          .from(TABLE)
          .insert(params.toJson())
          .select()
          .single();

      ArticleComment comment =
          ArticleCommentEntity.fromJson(response).toModel();
      return Right(comment);
    } catch (e, stackTrace) {
      print('Caught an exception: $e');
      print('Stack Trace: $stackTrace');
      return Left(ServerFailure());
    }
  }
}
