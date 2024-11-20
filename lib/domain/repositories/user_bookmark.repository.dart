import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_bookmark.entity.dart';
import 'package:zippy/data/entity/user_bookmark_folder.entity.dart';
import 'package:zippy/data/sources/user_bookmark.source.dart';
import 'package:zippy/domain/model/user_bookmark.model.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/user_bookmark_folder.model.dart';

abstract class UserBookmarkRepository {
  Future<Either<Failure, List<UserBookmark>>> getUserBookmarks();
  Future<Either<Failure, List<UserBookmark>>> createUserBookmark(
      UserBookmarkEntity bookmark);
  Future<Either<Failure, List<UserBookmark>>> deleteUserBookmark(
      UserBookmarkEntity bookmark);
  Stream<List<UserBookmark>> subscribeUserBookmarks();
  Future<Either<Failure, List<UserBookmarkFolder>>> createUserBookmarkFolder(
      UserBookmarkFolderEntity folder);
  Future<Either<Failure, List<UserBookmarkFolder>>> deleteUserBookmarkFolder(
      UserBookmarkFolderEntity folder);
  Future<Either<Failure, List<UserBookmarkFolder>>> getUserBookmarkFolders();
  Stream<List<UserBookmarkFolder>> subscribeUserBookmarkFolders();
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

  @override
  Future<Either<Failure, List<UserBookmarkFolder>>> createUserBookmarkFolder(
      UserBookmarkFolderEntity folder) {
    return datasource.createFolder(folder);
  }

  @override
  Future<Either<Failure, List<UserBookmarkFolder>>> deleteUserBookmarkFolder(
      UserBookmarkFolderEntity folder) {
    return datasource.deleteFolder(folder.id);
  }

  @override
  Future<Either<Failure, List<UserBookmarkFolder>>> getUserBookmarkFolders() {
    return datasource.getFolders();
  }

  @override
  Stream<List<UserBookmarkFolder>> subscribeUserBookmarkFolders() {
    return datasource.subscribeUserBookmarkFolders();
  }
}
