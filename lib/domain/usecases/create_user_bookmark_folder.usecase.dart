import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/params/create_bookmark_folder.params.dart';
import 'package:zippy/domain/repositories/user_bookmark.repository.dart';

class CreateUserBookmarkFolder {
  final UserBookmarkRepository repo;

  CreateUserBookmarkFolder(this.repo);

  Future<Either<Failure, bool>> execute(CreateBookmarkFolderParams folder) {
    return repo.createUserBookmarkFolder(folder);
  }
}
