import 'package:zippy/domain/repositories/interfaces/content_repository.dart';

class UpContentViewCount {
  final ContentRepository repo;

  UpContentViewCount(this.repo);

  Future<void> execute(int id) {
    return repo.upContentViewCount(id);
  }
}
