import 'package:cocomu/app/failures/failure.dart';
import 'package:cocomu/domain/repositories/interfaces/user_repository.dart';
import 'package:dartz/dartz.dart';

class Logout {
  final UserRepository repo;

  Logout(this.repo);

  Future<Either<Failure, bool>> execute() {
    return repo.logout();
  }
}
