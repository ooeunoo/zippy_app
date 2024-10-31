import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/usecases/loginin_with_kakao.usecase.dart';

class LoginController extends GetxController {
  final LoginInWithKakao loginInWithKakao;

  LoginController(this.loginInWithKakao);

  @override
  onInit() async {
    super.onInit();
  }

  onClickLoginInWithKakao() async {
    Either<Failure, bool> result = await loginInWithKakao.execute();
  }
}
