import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/auth.repository.dart';

class LoginWithGoogle {
  final AuthRepository repo = Get.find();

  Future<Either<Failure, bool>> execute() {
    return repo.loginWithGoogle();
  }
}
