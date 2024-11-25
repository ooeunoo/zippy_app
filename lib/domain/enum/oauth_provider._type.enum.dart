import 'package:flutter/material.dart';
import 'package:zippy/app/styles/color.dart';

enum OAuthProviderType {
  APPLE('assets/icons/apple.svg', AppColor.white),
  GOOGLE('assets/icons/google.svg', AppColor.transparent),
  KAKAO('assets/icons/kakao.svg', AppColor.kakaoBackground),
  ;

  final String image;
  final Color color;
  const OAuthProviderType(this.image, this.color);
}
