import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/auth.repository.dart';

class LoginInWithKakao {
  final AuthRepository repo;

  LoginInWithKakao(this.repo);

  Future<Either<Failure, bool>> execute() {
    return repo.loginWithKakao();
  }
}
