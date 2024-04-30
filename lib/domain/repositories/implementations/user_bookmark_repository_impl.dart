import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_bookmark_entity.dart';
import 'package:zippy/data/sources/interfaces/user_bookmark_data_source.dart';
import 'package:zippy/domain/model/user_bookmark.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/interfaces/user_bookmark_repository.dart';

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
