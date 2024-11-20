import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/data/entity/user_bookmark_folder.entity.dart';
import 'package:zippy/domain/model/user_bookmark_folder.model.dart';
import 'package:zippy/domain/repositories/user_bookmark.repository.dart';

class DeleteUserBookmarkFolder {
  final UserBookmarkRepository repo;

  DeleteUserBookmarkFolder(this.repo);

  Future<Either<Failure, List<UserBookmarkFolder>>> execute(
      UserBookmarkFolderEntity folder) {
    return repo.deleteUserBookmarkFolder(folder);
  }
}
