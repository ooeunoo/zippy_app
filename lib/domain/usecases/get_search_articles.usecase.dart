import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/params/get_search_articles.params.dart';
import 'package:zippy/domain/repositories/article.repository.dart';

class GetSearchArticles {
  final ArticleRepository repo = Get.find();

  Future<Either<Failure, List<Article>>> execute(
      GetSearchArticlesParams params) {
    return repo.getSearchArticles(params);
  }
}
