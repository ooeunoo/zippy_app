import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/user_bookmark.repository.dart';

class DeleteUserBookmark {
  final UserBookmarkRepository repo;

  DeleteUserBookmark(this.repo);

  Future<Either<Failure, bool>> execute(int bookmarkId) {
    return repo.deleteUserBookmark(bookmarkId);
  }
}
