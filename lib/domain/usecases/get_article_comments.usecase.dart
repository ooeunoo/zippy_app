import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/article_comment.model.dart';
import 'package:zippy/domain/repositories/article_comment.repository.dart';

class GetArticleComments {
  final ArticleCommentRepository repo = Get.find();

  Future<Either<Failure, List<ArticleComment>>> execute(int articleId) {
    return repo.getComments(articleId);
  }
}
