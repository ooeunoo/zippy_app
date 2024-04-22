import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/repositories/interfaces/user_repository.dart';
import 'package:dartz/dartz.dart';

class Logout {
  final UserRepository repo;

  Logout(this.repo);

  Future<Either<Failure, bool>> execute() {
    return repo.logout();
  }
}
