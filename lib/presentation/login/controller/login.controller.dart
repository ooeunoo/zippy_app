import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/usecases/loginin_with_kakao.usecase.dart';

class LoginController extends GetxController {
  final LoginInWithKakao loginInWithKakao;

  LoginController(this.loginInWithKakao);

  onClickLoginInWithKakao() async {
    Either<Failure, bool> result = await loginInWithKakao.execute();
    if (result.isRight()) {
      // check navigator get back
      if (Navigator.canPop(Get.context!)) {
        Navigator.pop(Get.context!);
      }
      print('login success');
    }
  }
}
