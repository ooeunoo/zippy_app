import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_bookmark_entity.dart';
import "package:dartz/dartz.dart";
import 'package:zippy/domain/model/user_bookmark.dart';

abstract class UserBookmarkDatasource {
  Future<Either<Failure, List<UserBookmark>>> createBookmark(
      UserBookmarkEntity bookmark);
  Future<Either<Failure, List<UserBookmark>>> deleteBookmark(
      UserBookmarkEntity bookmark);
  Future<Either<Failure, List<UserBookmark>>> getBookmarks();
  Stream<List<UserBookmark>> subscribeUserBookmarks();
}
