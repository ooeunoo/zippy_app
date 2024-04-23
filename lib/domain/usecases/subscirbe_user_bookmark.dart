import 'package:zippy/domain/model/bookmark.dart';
import 'package:zippy/domain/repositories/interfaces/bookmark_repository.dart';

class SubscribeUserBookmark {
  final BookmarkRepository repo;

  SubscribeUserBookmark(this.repo);

  Stream<List<Bookmark>> execute(String userId) {
    return repo.subscribeUserBookmark(userId);
  }
}
