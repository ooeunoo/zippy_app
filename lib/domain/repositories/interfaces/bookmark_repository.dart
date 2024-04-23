import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/bookmark_entity.dart';
import 'package:zippy/domain/model/bookmark.dart';
import 'package:dartz/dartz.dart';

abstract class BookmarkRepository {
  Future<Either<Failure, List<Bookmark>>> getBookmarksByUserId(String userId,
      {bool withItem = false});
  Future<Either<Failure, bool>> createBookmark(BookmarkEntity bookmark);
  Future<Either<Failure, bool>> deleteBookmark(BookmarkEntity bookmark);
  Stream<List<Bookmark>> subscribeUserBookmark(String userId);
}
