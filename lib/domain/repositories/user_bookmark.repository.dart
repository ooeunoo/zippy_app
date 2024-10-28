import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_bookmark.entity.dart';
import 'package:zippy/data/sources/user_bookmark.source.dart';
import 'package:zippy/domain/model/user_bookmark.model.dart';
import 'package:dartz/dartz.dart';

abstract class UserBookmarkRepository {
  Future<Either<Failure, List<UserBookmark>>> getUserBookmarks();
  Future<Either<Failure, List<UserBookmark>>> createUserBookmark(
      UserBookmarkEntity bookmark);
  Future<Either<Failure, List<UserBookmark>>> deleteUserBookmark(
      UserBookmarkEntity bookmark);
  Stream<List<UserBookmark>> subscribeUserBookmarks();
}

class UserBookmarkRepositoryImpl implements UserBookmarkRepository {
  final UserBookmarkDatasource datasource;

  UserBookmarkRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<UserBookmark>>> createUserBookmark(
      UserBookmarkEntity bookmark) {
    return datasource.createBookmark(bookmark);
  }

  @override
  Future<Either<Failure, List<UserBookmark>>> deleteUserBookmark(
      UserBookmarkEntity bookmark) {
    return datasource.deleteBookmark(bookmark);
  }

  @override
  Future<Either<Failure, List<UserBookmark>>> getUserBookmarks() {
    return datasource.getBookmarks();
  }

  @override
  Stream<List<UserBookmark>> subscribeUserBookmarks() {
    return datasource.subscribeUserBookmarks();
  }
}
