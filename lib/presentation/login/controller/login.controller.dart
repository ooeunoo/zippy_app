import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/usecases/login_with_kakao.usecase.dart';

class LoginController extends GetxController {
  final LoginWithKakao loginInWithKakao;

  LoginController(this.loginInWithKakao);

  onClickLoginInWithKakao() async {
    Either<Failure, bool> result = await loginInWithKakao.execute();
    if (result.isRight()) {
      if (Navigator.canPop(Get.context!)) {
        Navigator.pop(Get.context!);
      }
    }
  }
}
