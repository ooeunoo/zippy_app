import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/user_bookmark_folder.model.dart';
import 'package:zippy/domain/repositories/user_bookmark.repository.dart';

class GetUserBookmarkFolders {
  final UserBookmarkRepository repo;

  GetUserBookmarkFolders(this.repo);

  Future<Either<Failure, List<UserBookmarkFolder>>> execute() {
    return repo.getUserBookmarkFolders();
  }
}
