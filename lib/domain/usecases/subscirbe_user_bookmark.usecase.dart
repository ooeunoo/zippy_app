import 'package:zippy/domain/model/user_bookmark_item.model.dart';
import 'package:zippy/domain/repositories/user_bookmark.repository.dart';

class SubscribeUserBookmark {
  final UserBookmarkRepository repo;

  SubscribeUserBookmark(this.repo);

  Stream<List<UserBookmarkItem>> execute(String userId) {
    return repo.subscribeUserBookmarks(userId);
  }
}
