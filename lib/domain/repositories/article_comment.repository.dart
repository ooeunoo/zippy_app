import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/sources/article_comment.source.dart';
import 'package:zippy/domain/model/article_comment.model.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/params/create_article_comment.params.dart';

abstract class ArticleCommentRepository {
  Future<Either<Failure, List<ArticleComment>>> getComments(int articleId);
  Future<Either<Failure, ArticleComment>> createComment(
      CreateArticleCommentParams params);
}

class ArticleCommentRepositoryImpl implements ArticleCommentRepository {
  final ArticleCommentDatasource datasource;

  ArticleCommentRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<ArticleComment>>> getComments(int articleId) {
    return datasource.getComments(articleId);
  }

  @override
  Future<Either<Failure, ArticleComment>> createComment(
      CreateArticleCommentParams params) {
    return datasource.createComment(params);
  }
}
