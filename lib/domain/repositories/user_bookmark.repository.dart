import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/sources/user_bookmark.source.dart';
import 'package:zippy/domain/model/params/create_bookmark_folder.params.dart';
import 'package:zippy/domain/model/params/create_bookmark_item.params.dart';
import 'package:zippy/domain/model/user_bookmark_item.model.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/user_bookmark_folder.model.dart';

abstract class UserBookmarkRepository {
  Future<Either<Failure, List<UserBookmarkItem>>> getUserBookmarks(
      String userId);
  Future<Either<Failure, bool>> createUserBookmark(
      CreateBookmarkItemParams bookmark);
  Future<Either<Failure, bool>> deleteUserBookmark(int bookmarkId);
  Stream<List<UserBookmarkItem>> subscribeUserBookmarks(String userId);

  Future<Either<Failure, bool>> createUserBookmarkFolder(
      CreateBookmarkFolderParams folder);
  Future<Either<Failure, bool>> deleteUserBookmarkFolder(int folderId);
  Future<Either<Failure, List<UserBookmarkFolder>>> getUserBookmarkFolders(
      String userId);
  Stream<List<UserBookmarkFolder>> subscribeUserBookmarkFolders(String userId);
}

class UserBookmarkRepositoryImpl implements UserBookmarkRepository {
  final UserBookmarkDatasource datasource;

  UserBookmarkRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, bool>> createUserBookmark(
      CreateBookmarkItemParams bookmark) {
    return datasource.createUserBookmark(bookmark);
  }

  @override
  Future<Either<Failure, bool>> deleteUserBookmark(int bookmarkId) {
    return datasource.deleteUserBookmark(bookmarkId);
  }

  @override
  Future<Either<Failure, List<UserBookmarkItem>>> getUserBookmarks(
      String userId) {
    return datasource.getUserBookmarks(userId);
  }

  @override
  Stream<List<UserBookmarkItem>> subscribeUserBookmarks(String userId) {
    return datasource.subscribeUserBookmarks(userId);
  }

  @override
  Future<Either<Failure, bool>> createUserBookmarkFolder(
      CreateBookmarkFolderParams folder) {
    return datasource.createUserBookmarkFolder(folder);
  }

  @override
  Future<Either<Failure, bool>> deleteUserBookmarkFolder(int folderId) {
    return datasource.deleteUserBookmarkFolder(folderId);
  }

  @override
  Future<Either<Failure, List<UserBookmarkFolder>>> getUserBookmarkFolders(
      String userId) {
    return datasource.getUserBookmarkFolders(userId);
  }

  @override
  Stream<List<UserBookmarkFolder>> subscribeUserBookmarkFolders(String userId) {
    return datasource.subscribeUserBookmarkFolders(userId);
  }
}
