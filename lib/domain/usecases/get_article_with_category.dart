import 'package:dartz/dartz.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/article_cached.model.dart';
import 'package:zippy/domain/repositories/article.repository.dart';

class GetArticleWithCategory {
  final ArticleRepository repo;

  GetArticleWithCategory(this.repo);

  Future<Either<Failure, ArticleWithCategoryGroup>> execute(int contentTypeId) {
    return repo.getArticlesForCategories(contentTypeId);
  }
}
