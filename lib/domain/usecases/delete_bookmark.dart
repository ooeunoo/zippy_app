import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/bookmark_entity.dart';
import 'package:zippy/domain/repositories/interfaces/bookmark_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteBookmark {
  final BookmarkRepository repo;

  DeleteBookmark(this.repo);

  Future<Either<Failure, bool>> execute(BookmarkEntity bookmark) {
    return repo.deleteBookmark(bookmark);
  }
}
