import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user.entity.dart' as userEntity;
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:zippy/data/sources/user.source.dart';
import 'package:zippy/domain/model/user.model.dart' as userModel;

abstract class AuthDatasource {
  Future<Either<Failure, userModel.User?>> getCurrentUser();
  Stream<Tuple2<supabase.AuthChangeEvent, userModel.User?>>
      subscribeAuthStatus();
  Future<Either<Failure, bool>> logout();
  bool isAuthenticated();
  Future<Either<Failure, userModel.User>> loginInWithEmail(
      String email, String password);
  Future<Either<Failure, bool>> loginInWithKakao();
}

class AuthDatasourceImpl implements AuthDatasource {
  SupabaseProvider provider = Get.find();
  UserDatasource userDatasource = Get.find();

  @override
  Future<Either<Failure, userModel.User?>> getCurrentUser() async {
    try {
      final currentUser = provider.client.auth.currentUser;
      if (currentUser == null) {
        return const Right(null);
      }
      Either<Failure, userModel.User?> result =
          await userDatasource.getUser(currentUser.id);

      return result;
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Stream<Tuple2<supabase.AuthChangeEvent, userModel.User?>>
      subscribeAuthStatus() {
    return provider.client.auth.onAuthStateChange.asyncMap((change) async {
      final event = change.event;
      final authUser = change.session?.user;

      if (authUser == null) {
        return Tuple2(event, null);
      }

      final Either<Failure, userModel.User?> result =
          await userDatasource.getUser(authUser.id);
      return result.fold(
        (failure) => Tuple2(event, null),
        (user) => Tuple2(event, user),
      );
    });
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await provider.client.auth.signOut();
      return const Right(true);
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  bool isAuthenticated() {
    return provider.client.auth.currentSession != null;
  }

  // 세션 새로고침을 위한 메서드
  Future<Either<Failure, userModel.User>> refreshSession() async {
    try {
      final response = await provider.client.auth.refreshSession();
      if (response.session == null) {
        return Left(ServerFailure());
      }

      userModel.User user =
          userEntity.UserEntity.fromJson(response.user!.toJson()).toModel();
      return Right(user);
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  // 세션 만료 체크
  bool isSessionExpired() {
    final session = provider.client.auth.currentSession;
    if (session == null) return true;

    final expiresAt =
        DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000);
    return DateTime.now().isAfter(expiresAt);
  }

  @override
  Future<Either<Failure, userModel.User>> loginInWithEmail(
      String email, String password) async {
    try {
      supabase.AuthResponse response = await provider.client.auth
          .signInWithPassword(email: email, password: password);

      userModel.User user =
          userEntity.UserEntity.fromJson(response.user!.toJson()).toModel();
      return Right(user);
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> loginInWithKakao() async {
    try {
      // await provider.client.auth.signInWithOAuth(
      //   supabase.OAuthProvider.kakao,
      //   redirectTo: kIsWeb
      //       ? null
      //       : 'com.miro.zippy://oauth', // Optionally set the redirect link to bring back the user via deeplink.
      //   authScreenLaunchMode: kIsWeb
      //       ? LaunchMode.platformDefault
      //       : LaunchMode
      //           .inAppWebView, // Launch the auth screen in a new webview on mobile.
      // );
      OAuthToken? token;
      if (await isKakaoTalkInstalled()) {
        try {
          token = await UserApi.instance.loginWithKakaoTalk();
          print('token:$token');
        } catch (error) {
          print('Error:$error');
          // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
          // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
          if (error is PlatformException && error.code == 'CANCELED') {
            return const Right(false);
          }
          // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
          try {
            token = await UserApi.instance.loginWithKakaoAccount();
          } catch (error) {
            print('Error1:$error');
            return const Right(false);
          }
        }
      } else {
        try {
          token = await UserApi.instance.loginWithKakaoAccount();
        } catch (error) {
          print('Error2:$error');
          return const Right(false);
        }
      }
      await provider.client.auth.signInWithIdToken(
        provider: supabase.OAuthProvider.kakao,
        idToken: token.idToken!,
        accessToken: token.accessToken,
      );

      return const Right(true);
    } catch (e, stackTrace) {
      print('Error3:$e');
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }
}
