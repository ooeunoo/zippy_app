import 'package:zippy/domain/model/user_category.dart';
import 'package:zippy/domain/repositories/interfaces/user_category_repository.dart';

class SubscribeUserCategory {
  final UserCategoryRepository repo;

  SubscribeUserCategory(this.repo);

  Stream<List<UserCategory>> execute() {
    return repo.subscribeUserCategories();
  }
}
