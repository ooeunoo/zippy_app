import 'package:zippy/domain/model/user_bookmark_item.model.dart';
import 'package:zippy/domain/model/user_bookmark_folder.model.dart';
import 'package:zippy/domain/repositories/user_bookmark.repository.dart';

class SubscribeUserBookmarkFolder {
  final UserBookmarkRepository repo;

  SubscribeUserBookmarkFolder(this.repo);

  Stream<List<UserBookmarkFolder>> execute(String userId) {
    return repo.subscribeUserBookmarkFolders(userId);
  }
}
