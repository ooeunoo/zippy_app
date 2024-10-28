// platform_datasource_integration_test.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zippy/app/utils/assets.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:zippy/data/sources/platform.source.dart';

void main() {
  late PlatformDatasourceIml datasource;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // SharedPreferences 모의 설정
    SharedPreferences.setMockInitialValues({});

    // 환경 변수 로드
    await dotenv.load(fileName: Assets.envDev);

    // Supabase 초기화
    await SupabaseProvider.init();
    Get.put<SupabaseProvider>(SupabaseProvider());

    datasource = PlatformDatasourceIml();
  });

  tearDownAll(() {
    Get.reset();
  });

  test('getPlatforms should return actual platforms', () async {
    try {
      // Act
      final result = await datasource.getPlatforms();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) {
          print('Failure occurred: $failure');
          fail('Should not return failure');
        },
        (platforms) {
          print('Retrieved ${platforms.length} platforms');
          platforms.forEach((platform) {
            print('Platform: ${platform.id} - ${platform.name}');
          });
          expect(platforms, isNotEmpty);
        },
      );
    } catch (e, stackTrace) {
      print('Test error: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }, timeout: Timeout(Duration(minutes: 1)));
}
