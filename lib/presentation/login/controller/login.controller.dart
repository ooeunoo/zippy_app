import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/usecases/login_with_apple.usecase.dart';
import 'package:zippy/domain/usecases/login_with_google.usecase.dart';
import 'package:zippy/domain/usecases/login_with_kakao.usecase.dart';

class LoginController extends GetxController {
  final LoginWithKakao loginInWithKakao = Get.find();
  final LoginWithGoogle loginInWithGoogle = Get.find();
  final LoginWithApple loginInWithApple = Get.find();

  onClickLoginInWithKakao() async {
    Either<Failure, bool> result = await loginInWithKakao.execute();
    if (result.isRight()) {
      if (Navigator.canPop(Get.context!)) {
        Navigator.pop(Get.context!);
      }
    }
  }

  onClickLoginInWithGoogle() async {
    Either<Failure, bool> result = await loginInWithGoogle.execute();
    if (result.isRight()) {
      if (Navigator.canPop(Get.context!)) {
        Navigator.pop(Get.context!);
      }
    }
  }

  onClickLoginInWithApple() async {
    Either<Failure, bool> result = await loginInWithApple.execute();
    if (result.isRight()) {
      if (Navigator.canPop(Get.context!)) {
        Navigator.pop(Get.context!);
      }
    }
  }
}
