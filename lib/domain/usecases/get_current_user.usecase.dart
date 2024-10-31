import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/user.model.dart';
import 'package:zippy/domain/repositories/auth.repository.dart';

class GetCurrentUser {
  final AuthRepository repo;

  GetCurrentUser(this.repo);

  Future<Either<Failure, User?>> execute() {
    return repo.getCurrentUser();
  }
}
