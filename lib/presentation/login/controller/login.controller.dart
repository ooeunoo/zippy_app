import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/app/services/admob.service.dart';
import 'package:zippy/domain/usecases/login_with_apple.usecase.dart';
import 'package:zippy/domain/usecases/login_with_google.usecase.dart';
import 'package:zippy/domain/usecases/login_with_kakao.usecase.dart';

class LoginController extends GetxController {
  final LoginWithKakao loginInWithKakao = Get.find();
  final LoginWithGoogle loginInWithGoogle = Get.find();
  final LoginWithApple loginInWithApple = Get.find();
  final AdmobService admobService = Get.find();

  Future<void> _handleSuccessfulLogin() async {
    if (Navigator.canPop(Get.context!)) {
      // 현재 광고 dispose
      await admobService.bottomBannerAd.value?.dispose();
      admobService.bottomBannerAd.value = null;
      admobService.isBottomBannerAdLoaded.value = false;

      // Navigator.pop(Get.context!);
      Get.back();
    }
  }

  onClickLoginInWithKakao() async {
    Either<Failure, bool> result = await loginInWithKakao.execute();
    if (result.isRight()) {
      await _handleSuccessfulLogin();
    }
  }

  onClickLoginInWithGoogle() async {
    Either<Failure, bool> result = await loginInWithGoogle.execute();
    if (result.isRight()) {
      await _handleSuccessfulLogin();
    }
  }

  onClickLoginInWithApple() async {
    Either<Failure, bool> result = await loginInWithApple.execute();
    if (result.isRight()) {
      await _handleSuccessfulLogin();
    }
  }
}
