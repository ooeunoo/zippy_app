import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/user_bookmark.repository.dart';

class DeleteUserBookmarkFolder {
  final UserBookmarkRepository repo;

  DeleteUserBookmarkFolder(this.repo);

  Future<Either<Failure, bool>> execute(int folderId) {
    return repo.deleteUserBookmarkFolder(folderId);
  }
}
