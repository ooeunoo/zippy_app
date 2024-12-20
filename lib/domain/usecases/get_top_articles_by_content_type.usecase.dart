import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/params/get_top_articles_by_content_type.params.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/top_articles_by_content_type.model.dart';
import 'package:zippy/domain/repositories/article.repository.dart';

class GetTopArticlesByContentType {
  final ArticleRepository repo;

  GetTopArticlesByContentType(this.repo);

  Future<Either<Failure, List<TopArticlesByContentType>>> execute(
      GetTopArticlesByContentTypeParams params) {
    return repo.getTopArticlesByContentType(params);
  }
}
