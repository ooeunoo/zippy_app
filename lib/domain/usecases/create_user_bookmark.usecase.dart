import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_bookmark.entity.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/user_bookmark.model.dart';
import 'package:zippy/domain/repositories/user_bookmark.repository.dart';

class CreateUserBookmark {
  final UserBookmarkRepository repo;

  CreateUserBookmark(this.repo);

  Future<Either<Failure, List<UserBookmark>>> execute(
      UserBookmarkEntity bookmark) {
    return repo.createUserBookmark(bookmark);
  }
}
