import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:zippy/app/utils/env.dart';

class KakaoProvider {
  static init() async {
    KakaoSdk.init(
      nativeAppKey: ENV.KAKAO_NATIVE_APP_KEY,
    );
  }
}
