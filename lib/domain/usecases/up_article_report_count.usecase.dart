import 'package:zippy/domain/repositories/article.repository.dart';

class UpArticleReportCount {
  final ArticleRepository repo;

  UpArticleReportCount(this.repo);

  Future<void> execute(int id) {
    return repo.upArticleReportCount(id);
  }
}
