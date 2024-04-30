import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_bookmark_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/user_bookmark.dart';

abstract class UserBookmarkRepository {
  Future<Either<Failure, List<UserBookmark>>> getUserBookmarks();
  Future<Either<Failure, List<UserBookmark>>> createUserBookmark(
      UserBookmarkEntity bookmark);
  Future<Either<Failure, List<UserBookmark>>> deleteUserBookmark(
      UserBookmarkEntity bookmark);
  Stream<List<UserBookmark>> subscribeUserBookmarks();
}
