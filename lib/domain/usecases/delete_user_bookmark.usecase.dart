import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_bookmark.entity.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/user_bookmark.model.dart';
import 'package:zippy/domain/repositories/user_bookmark.repository.dart';

class DeleteUserBookmark {
  final UserBookmarkRepository repo;

  DeleteUserBookmark(this.repo);

  Future<Either<Failure, List<UserBookmark>>> execute(
      int bookmarkId) {
    return repo.deleteUserBookmark(bookmarkId);
  }
}
