import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_bookmark_item.entity.dart';
import 'package:zippy/data/entity/user_bookmark_folder.entity.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:zippy/domain/model/params/create_bookmark_folder.params.dart';
import 'package:zippy/domain/model/params/create_bookmark_item.params.dart';
import 'package:zippy/domain/model/user_bookmark_item.model.dart';
import 'package:zippy/domain/model/user_bookmark_folder.model.dart';

String USER_BOOKMARK_FOLDERS = 'user_bookmark_folders';
String USER_BOOKMARK_ITEMS = 'user_bookmark_items';

abstract class UserBookmarkDatasource {
  // 북마크 관련
  Future<Either<Failure, bool>> createUserBookmark(
      CreateBookmarkItemParams bookmark);
  Future<Either<Failure, bool>> deleteUserBookmark(int bookmarkId);
  Future<Either<Failure, List<UserBookmarkItem>>> getUserBookmarks(
      String userId);
  Future<Either<Failure, List<UserBookmarkItem>>> getUserBookmarksByFolderId(
      String userId, int folderId);
  Stream<List<UserBookmarkItem>> subscribeUserBookmarks(String userId);

  // 폴더 관련
  Future<Either<Failure, bool>> createUserBookmarkFolder(
      CreateBookmarkFolderParams folder);
  Future<Either<Failure, bool>> deleteUserBookmarkFolder(int folderId);
  Future<Either<Failure, List<UserBookmarkFolder>>> getUserBookmarkFolders(
      String userId);
  Stream<List<UserBookmarkFolder>> subscribeUserBookmarkFolders(String userId);
}

class UserBookmarkDatasourceImpl implements UserBookmarkDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, bool>> createUserBookmark(
      CreateBookmarkItemParams newBookmark) async {
    try {
      await provider.client
          .from(USER_BOOKMARK_ITEMS)
          .insert(newBookmark.toJson());

      return const Right(true);
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteUserBookmark(int removeBookmarkId) async {
    try {
      await provider.client
          .from(USER_BOOKMARK_ITEMS)
          .delete()
          .eq('id', removeBookmarkId);
      return const Right(true);
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserBookmarkItem>>> getUserBookmarks(
      String userId) async {
    try {
      List<Map<String, dynamic>> response = await provider.client
          .from(USER_BOOKMARK_ITEMS)
          .select('*, articles(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return Right(response
          .map((e) => UserBookmarkItemEntity.fromJson(e).toModel())
          .toList());
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserBookmarkItem>>> getUserBookmarksByFolderId(
      String userId, int folderId) async {
    try {
      List<Map<String, dynamic>> response = await provider.client
          .from(USER_BOOKMARK_ITEMS)
          .select('*')
          .eq('user_id', userId)
          .eq('folder_id', folderId)
          .order('created_at', ascending: false);
      return Right(response
          .map((e) => UserBookmarkItemEntity.fromJson(e).toModel())
          .toList());
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Stream<List<UserBookmarkItem>> subscribeUserBookmarks(String userId) {
    return provider.client
        .from(USER_BOOKMARK_ITEMS)
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('id', ascending: true)
        .map((event) => event
            .map((e) => UserBookmarkItemEntity.fromJson(e).toModel())
            .toList());
  }

  // 폴더 관련 메서드 구현
  @override
  Future<Either<Failure, bool>> createUserBookmarkFolder(
      CreateBookmarkFolderParams newFolder) async {
    try {
      await provider.client
          .from(USER_BOOKMARK_FOLDERS)
          .insert(newFolder.toJson());
      return const Right(true);
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteUserBookmarkFolder(int folderId) async {
    try {
      await provider.client
          .from(USER_BOOKMARK_ITEMS)
          .delete()
          .eq('folder_id', folderId);

      await provider.client
          .from(USER_BOOKMARK_FOLDERS)
          .delete()
          .eq('id', folderId);

      return const Right(true);
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserBookmarkFolder>>> getUserBookmarkFolders(
      String userId) async {
    try {
      List<Map<String, dynamic>> response = await provider.client
          .from(USER_BOOKMARK_FOLDERS)
          .select('*')
          .eq('user_id', userId)
          .order('id', ascending: true);
      return Right(response
          .map((e) => UserBookmarkFolderEntity.fromJson(e).toModel())
          .toList());
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Stream<List<UserBookmarkFolder>> subscribeUserBookmarkFolders(String userId) {
    return provider.client
        .from(USER_BOOKMARK_FOLDERS)
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('id', ascending: true)
        .map((event) => event
            .map((e) => UserBookmarkFolderEntity.fromJson(e).toModel())
            .toList());
  }
}
