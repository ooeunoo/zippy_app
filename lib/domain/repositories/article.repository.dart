import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/sources/article.source.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/params/get_aritlces.params.dart';
import 'package:zippy/domain/model/params/get_articles_by_keyword.params.dart';
import 'package:zippy/domain/model/params/get_recommend_aritlces.params.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';
import 'package:dartz/dartz.dart';

abstract class ArticleRepository {
  Future<Either<Failure, List<Article>>> getRecommendedArticles(
      GetRecommendedArticlesParams params);
  Future<Either<Failure, List<Article>>> getArticles(GetArticlesParams params);
  Future<Either<Failure, List<Article>>> getArticlesByKeyword(
      GetArticlesByKeywordParams params);
  Future<Either<Failure, Article>> getArticle(int id);
}

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleDatasource datasource;

  ArticleRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Article>>> getRecommendedArticles(
      GetRecommendedArticlesParams params) {
    return datasource.getRecommendedArticles(params);
  }

  @override
  Future<Either<Failure, List<Article>>> getArticles(GetArticlesParams params) {
    return datasource.getArticles(params);
  }

  @override
  Future<Either<Failure, List<Article>>> getArticlesByKeyword(
      GetArticlesByKeywordParams params) {
    return datasource.getArticlesByKeyword(params);
  }

  @override
  Future<Either<Failure, Article>> getArticle(int id) {
    return datasource.getArticle(id);
  }
}
