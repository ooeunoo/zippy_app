import 'package:zippy/domain/model/content.dart';
import 'package:zippy/domain/model/user_category.dart';
import 'package:zippy/domain/repositories/interfaces/content_repository.dart';

class SubscribeContents {
  final ContentRepository repo;

  SubscribeContents(this.repo);

  Stream<List<Content>> execute(List<UserCategory> categories) {
    return repo.subscribeContents(categories);
  }
}
