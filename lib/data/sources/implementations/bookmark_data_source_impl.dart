// ignore_for_file: non_constant_identifier_names

import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/bookmark_entity.dart';
import 'package:zippy/data/providers/supabase_provider.dart';
import 'package:zippy/data/sources/interfaces/bookmark_data.source.dart';
import 'package:zippy/domain/model/bookmark.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

String TABLE = 'bookmark';

class BookmarkDatasourceIml implements BookmarkDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, bool>> createBookmark(BookmarkEntity bookmark) async {
    try {
      await provider.client.from(TABLE).insert(bookmark.toParams());
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteBookmark(BookmarkEntity bookmark) async {
    try {
      await provider.client.from(TABLE).delete().match(bookmark.toParams());
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Bookmark>>> getBookmarksByUserId(String userId,
      {bool withItem = false}) async {
    try {
      String selectString = '*';
      if (withItem) {
        selectString += ', item(*)';
      }

      List<Map<String, dynamic>> response = await provider.client
          .from(TABLE)
          .select(selectString)
          .match({"user_id": userId});
      List<Bookmark> result =
          response.map((r) => BookmarkEntity.fromJson(r).toModel()).toList();
      return Right(result);
    } catch (e) {
      print(e);
      return Left(ServerFailure());
    }
  }
}
