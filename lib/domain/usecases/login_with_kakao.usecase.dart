import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/auth.repository.dart';

class LoginWithKakao {
  final AuthRepository repo;

  LoginWithKakao(this.repo);

  Future<Either<Failure, bool>> execute() {
    return repo.loginWithKakao();
  }
}
