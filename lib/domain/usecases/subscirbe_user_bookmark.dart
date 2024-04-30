import 'package:zippy/domain/model/user_bookmark.dart';
import 'package:zippy/domain/repositories/interfaces/user_bookmark_repository.dart';

class SubscribeUserBookmark {
  final UserBookmarkRepository repo;

  SubscribeUserBookmark(this.repo);

  Stream<List<UserBookmark>> execute() {
    return repo.subscribeUserBookmarks();
  }
}
