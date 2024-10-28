import 'package:zippy/domain/repositories/article.repository.dart';

class UpArticleViewCount {
  final ArticleRepository repo;

  UpArticleViewCount(this.repo);

  Future<void> execute(int id) {
    return repo.upArticleViewCount(id);
  }
}
