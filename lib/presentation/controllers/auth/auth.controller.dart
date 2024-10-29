import 'package:get/get.dart';
import 'package:zippy/data/sources/auth.source.dart';
import 'package:zippy/domain/model/user.model.dart';

class AuthController extends GetxController {
  final AuthDatasource _authDatasource = Get.find();

  // 상태 관리용 변수들
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 초기 사용자 상태 로드
    _loadCurrentUser();

    // 인증 상태 변화 구독
    _authDatasource.authStateChanges().listen((user) {
      currentUser.value = user;
    });
  }

  Future<void> _loadCurrentUser() async {
    isLoading.value = true;
    try {
      final result = await _authDatasource.getCurrentUser();
      result.fold((failure) => null, (user) => currentUser.value = user);
    } finally {
      isLoading.value = false;
    }
  }

  // 로그인 메서드
  Future<void> loginWithEmail(String email, String password) async {
    isLoading.value = true;
    try {
      final result = await _authDatasource.loginInWithEmail(email, password);
      result.fold((failure) {
        Get.snackbar(
          '로그인 실패',
          '이메일 또는 비밀번호를 확인해주세요',
          snackPosition: SnackPosition.BOTTOM,
        );
      }, (user) {
        currentUser.value = user;
        Get.back(); // 로그인 성공 시 이전 페이지로 돌아가기
      });
    } finally {
      isLoading.value = false;
    }
  }

  // 로그아웃 메서드
  Future<void> signOut() async {
    isLoading.value = true;
    try {
      await _authDatasource.signOut();
      currentUser.value = null;
    } catch (e) {
      Get.snackbar(
        '오류',
        '로그아웃 중 문제가 발생했습니다',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // 로그인 여부 확인
  bool get isLoggedIn => currentUser.value != null;
}
