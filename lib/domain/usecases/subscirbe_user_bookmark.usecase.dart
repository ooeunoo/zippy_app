import 'package:zippy/domain/model/user_bookmark.model.dart';
import 'package:zippy/domain/repositories/user_bookmark.repository.dart';

class SubscribeUserBookmark {
  final UserBookmarkRepository repo;

  SubscribeUserBookmark(this.repo);

  Stream<List<UserBookmark>> execute() {
    return repo.subscribeUserBookmarks();
  }
}
