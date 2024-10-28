import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/user_bookmark.model.dart';
import 'package:zippy/domain/repositories/user_bookmark.repository.dart';

class GetUserBookmark {
  final UserBookmarkRepository repo;

  GetUserBookmark(this.repo);

  Future<Either<Failure, List<UserBookmark>>> execute() {
    return repo.getUserBookmarks();
  }
}
