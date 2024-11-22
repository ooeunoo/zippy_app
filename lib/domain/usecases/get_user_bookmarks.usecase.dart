import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/user_bookmark_item.model.dart';
import 'package:zippy/domain/repositories/user_bookmark.repository.dart';

class GetUserBookmarks {
  final UserBookmarkRepository repo;

  GetUserBookmarks(this.repo);

  Future<Either<Failure, List<UserBookmarkItem>>> execute(String userId) {
    return repo.getUserBookmarks(userId);
  }
}
