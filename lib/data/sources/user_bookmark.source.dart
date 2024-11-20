import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_bookmark.entity.dart';
import 'package:zippy/data/entity/user_bookmark_folder.entity.dart';
import 'package:zippy/data/providers/hive.provider.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/user_bookmark.model.dart';
import 'package:zippy/domain/model/user_bookmark_folder.model.dart';

enum UserBookmarkKey {
  all('전체보기'),
  folders('폴더목록'),
  ;

  const UserBookmarkKey(this.name);
  final String name;
}

abstract class UserBookmarkDatasource {
  // 북마크 관련
  Future<Either<Failure, List<UserBookmark>>> createBookmark(
      UserBookmarkEntity bookmark);
  Future<Either<Failure, List<UserBookmark>>> deleteBookmark(int bookmarkId);
  Future<Either<Failure, List<UserBookmark>>> getBookmarks();
  Future<Either<Failure, List<UserBookmark>>> getBookmarksByFolderId(
      int folderId);
  Stream<List<UserBookmark>> subscribeUserBookmarks();

  // 폴더 관련
  Future<Either<Failure, List<UserBookmarkFolder>>> createFolder(
      UserBookmarkFolderEntity folder);
  Future<Either<Failure, List<UserBookmarkFolder>>> deleteFolder(
      String folderId);
  Future<Either<Failure, List<UserBookmarkFolder>>> getFolders();
  Stream<List<UserBookmarkFolder>> subscribeUserBookmarkFolders();
}

class UserBookmarkDatasourceImpl implements UserBookmarkDatasource {
  var box = Get.find<HiveProvider>().userBookMarks!;
  var folderBox = Get.find<HiveProvider>().userBookmarkFolders!;

  @override
  Future<Either<Failure, List<UserBookmark>>> createBookmark(
      UserBookmarkEntity newBookmark) async {
    try {
      List<dynamic> bookmarks = _getBookmarks();
      bookmarks.add(newBookmark);
      await box.put(UserBookmarkKey.all.name, bookmarks);
      return Right(toBookmarkModelAll());
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserBookmark>>> deleteBookmark(
      int removeBookmarkId) async {
    try {
      List<dynamic> bookmarks = _getBookmarks();
      bookmarks.removeWhere((bookmark) => bookmark.id == removeBookmarkId);
      await box.put(UserBookmarkKey.all.name, bookmarks);
      return Right(toBookmarkModelAll());
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserBookmark>>> getBookmarks() async {
    try {
      return Right(toBookmarkModelAll());
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserBookmark>>> getBookmarksByFolderId(
      int folderId) async {
    try {
      final bookmarks = _getBookmarks();
      final filteredBookmarks = bookmarks
          .where((bookmark) => bookmark.folderId == folderId)
          .map((bookmark) => UserBookmark(
                id: bookmark.id,
                link: bookmark.link,
                title: bookmark.title,
                images: bookmark.images,
                folderId: bookmark.folderId,
              ))
          .toList();
      return Right(filteredBookmarks);
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Stream<List<UserBookmark>> subscribeUserBookmarks() {
    return box.watch().map((event) => toBookmarkModelAll());
  }

  // 폴더 관련 메서드 구현
  @override
  Future<Either<Failure, List<UserBookmarkFolder>>> createFolder(
      UserBookmarkFolderEntity newFolder) async {
    try {
      List<dynamic> folders = _getFolders();
      folders.add(newFolder);
      await folderBox.put(UserBookmarkKey.folders.name, folders);
      return Right(toFolderModelAll());
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserBookmarkFolder>>> deleteFolder(
      String folderId) async {
    try {
      // 폴더 삭제
      List<dynamic> folders = _getFolders();
      folders.removeWhere((folder) => folder.id == folderId);
      await folderBox.put(UserBookmarkKey.folders.name, folders);

      // 해당 폴더의 북마크들도 삭제
      List<dynamic> bookmarks = _getBookmarks();
      bookmarks.removeWhere((bookmark) => bookmark.folderId == folderId);
      await box.put(UserBookmarkKey.all.name, bookmarks);

      return Right(toFolderModelAll());
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserBookmarkFolder>>> getFolders() async {
    try {
      return Right(toFolderModelAll());
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Stream<List<UserBookmarkFolder>> subscribeUserBookmarkFolders() {
    return folderBox.watch().map((event) => toFolderModelAll());
  }

  // Private helper methods
  List<dynamic> _getBookmarks() {
    return box.get(UserBookmarkKey.all.name, defaultValue: []);
  }

  List<dynamic> _getFolders() {
    return folderBox.get(UserBookmarkKey.folders.name, defaultValue: []);
  }

  List<UserBookmark> toBookmarkModelAll() {
    return _getBookmarks()
        .map((bookmark) => UserBookmark(
              id: bookmark.id,
              link: bookmark.link,
              title: bookmark.title,
              images: bookmark.images,
              folderId: bookmark.folderId,
            ))
        .toList();
  }

  List<UserBookmarkFolder> toFolderModelAll() {
    return _getFolders()
        .map((folder) => UserBookmarkFolder(
              id: folder.id,
              name: folder.name,
              description: folder.description,
              createdAt: folder.createdAt,
            ))
        .toList();
  }
}
