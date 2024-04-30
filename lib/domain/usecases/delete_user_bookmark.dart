import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_bookmark_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/user_bookmark.dart';
import 'package:zippy/domain/repositories/interfaces/user_bookmark_repository.dart';

class DeleteUserBookmark {
  final UserBookmarkRepository repo;

  DeleteUserBookmark(this.repo);

  Future<Either<Failure, List<UserBookmark>>> execute(
      UserBookmarkEntity bookmark) {
    return repo.deleteUserBookmark(bookmark);
  }
}
