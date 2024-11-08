import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/article_comment.model.dart';
import 'package:zippy/domain/model/params/create_article_comment.params.dart';
import 'package:zippy/domain/repositories/article_comment.repository.dart';

class CreateArticleComment {
  final ArticleCommentRepository repo = Get.find();

  Future<Either<Failure, ArticleComment>> execute(
      CreateArticleCommentParams params) {
    return repo.createComment(params);
  }
}
