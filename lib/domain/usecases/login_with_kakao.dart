import 'package:cocomu/app/failures/failure.dart';
import 'package:cocomu/domain/repositories/interfaces/user_repository.dart';
import 'package:dartz/dartz.dart';

class LoginWithKakao {
  final UserRepository repo;

  LoginWithKakao(this.repo);

  Future<Either<Failure, bool>> execute() {
    return repo.loginWithKakao();
  }
}
