import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_bookmark_item.entity.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/params/create_bookmark_item.params.dart';
import 'package:zippy/domain/repositories/user_bookmark.repository.dart';

class CreateUserBookmark {
  final UserBookmarkRepository repo;

  CreateUserBookmark(this.repo);

  Future<Either<Failure, bool>> execute(CreateBookmarkItemParams bookmark) {
    return repo.createUserBookmark(bookmark);
  }
}
