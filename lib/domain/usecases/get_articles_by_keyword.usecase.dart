import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/article_comment.model.dart';
import 'package:zippy/domain/model/params/get_articles_by_keyword.params.dart';
import 'package:zippy/domain/repositories/article.repository.dart';
import 'package:zippy/domain/repositories/article_comment.repository.dart';

class GetArticlesByKeyword {
  final ArticleRepository repo = Get.find();

  Future<Either<Failure, List<Article>>> execute(
      GetArticlesByKeywordParams params) {
    return repo.getArticlesByKeyword(params);
  }
}
