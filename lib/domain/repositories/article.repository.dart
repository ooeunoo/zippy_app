import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/sources/article.source.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:zippy/domain/model/article_cached.model.dart';
import 'package:zippy/domain/model/params/get_articles_by_keyword.params.dart';
import 'package:zippy/domain/model/params/get_random_articles.params.dart';
import 'package:zippy/domain/model/params/get_recommend_aritlces.params.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/params/get_search_articles.params.dart';
import 'package:zippy/domain/model/params/get_top_articles_by_content_type.params.dart';
import 'package:zippy/domain/model/top_articles_by_content_type.model.dart';

abstract class ArticleRepository {
  Future<Either<Failure, List<Article>>> getRecommendedArticles(
      GetRecommendedArticlesParams params);
  Future<Either<Failure, List<Article>>> getSearchArticles(
      GetSearchArticlesParams params);
  Future<Either<Failure, List<Article>>> getArticlesByKeyword(
      GetArticlesByKeywordParams params);
  Future<Either<Failure, Article>> getArticle(int id);
  Future<Either<Failure, List<Article>>> GetRandomArticles(
      GetRandomArticlesParams params);
  Future<Either<Failure, List<TopArticlesByContentType>>>
      getTopArticlesByContentType(GetTopArticlesByContentTypeParams params);
  Future<Either<Failure, ArticleWithCategoryGroup>> getArticlesForCategories(
      int contentTypeId);
  Future<Either<Failure, List<Article>>> getArticlesByIds(List<int> ids);
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
  Future<Either<Failure, List<Article>>> getSearchArticles(
      GetSearchArticlesParams params) {
    return datasource.getSearchArticles(params);
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

  @override
  Future<Either<Failure, List<Article>>> GetRandomArticles(
      GetRandomArticlesParams params) {
    return datasource.GetRandomArticles(params);
  }

  @override
  Future<Either<Failure, List<TopArticlesByContentType>>>
      getTopArticlesByContentType(GetTopArticlesByContentTypeParams params) {
    return datasource.getTopArticlesByContentType(params);
  }

  @override
  Future<Either<Failure, ArticleWithCategoryGroup>> getArticlesForCategories(
      int contentTypeId) {
    return datasource.getArticlesForCategories(contentTypeId);
  }

  @override
  Future<Either<Failure, List<Article>>> getArticlesByIds(List<int> ids) {
    return datasource.getArticlesByIds(ids);
  }
}
