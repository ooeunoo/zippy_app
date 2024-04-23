import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/bookmark_entity.dart';
import 'package:zippy/data/sources/interfaces/bookmark_data.source.dart';
import 'package:zippy/domain/model/bookmark.dart';
import 'package:zippy/domain/repositories/interfaces/bookmark_repository.dart';
import 'package:dartz/dartz.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final BookmarkDatasource datasource;

  BookmarkRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Bookmark>>> getBookmarksByUserId(String userId,
      {bool withItem = false}) {
    return datasource.getBookmarksByUserId(userId, withItem: withItem);
  }

  @override
  Future<Either<Failure, bool>> createBookmark(BookmarkEntity bookmark) {
    return datasource.createBookmark(bookmark);
  }

  @override
  Future<Either<Failure, bool>> deleteBookmark(BookmarkEntity bookmark) {
    return datasource.deleteBookmark(bookmark);
  }

  @override
  Stream<List<Bookmark>> subscribeUserBookmark(String userId) {
    return datasource.subscribeUserBookmark(userId);
  }
}
