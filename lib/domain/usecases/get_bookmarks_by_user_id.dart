import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/bookmark.dart';
import 'package:zippy/domain/repositories/interfaces/bookmark_repository.dart';
import 'package:dartz/dartz.dart';

class GetBookmarksByUserId {
  final BookmarkRepository repo;

  GetBookmarksByUserId(this.repo);

  Future<Either<Failure, List<Bookmark>>> execute(String userId) {
    return repo.getBookmarksByUserId(userId);
  }
}
