import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user.entity.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:zippy/data/sources/user.source.dart';
import 'package:zippy/domain/model/user.model.dart';

abstract class AuthDatasource {
  Future<Either<Failure, User?>> getCurrentUser();
  Stream<User?> subscribeAuthStatus();
  Future<Either<Failure, bool>> logout();
  bool isAuthenticated();
  Future<Either<Failure, User>> loginInWithEmail(String email, String password);
  Future<Either<Failure, bool>> loginInWithKakao();
}

class AuthDatasourceImpl implements AuthDatasource {
  SupabaseProvider provider = Get.find();
  UserDatasource userDatasource = Get.find();

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final currentUser = provider.client.auth.currentUser;
      if (currentUser == null) {
        return const Right(null);
      }
      Either<Failure, User?> result =
          await userDatasource.getUser(currentUser.id);

      return result;
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Stream<User?> subscribeAuthStatus() {
    return provider.client.auth.onAuthStateChange.asyncMap((event) async {
      print(event);
      final authUser = event.session?.user;
      if (authUser == null) {
        return null;
      }

      final Either<Failure, User?> result =
          await userDatasource.getUser(authUser.id);
      print(result);
      return result.fold(
        (failure) => null,
        (user) => user,
      );
    });
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await provider.client.auth.signOut();
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  bool isAuthenticated() {
    return provider.client.auth.currentSession != null;
  }

  // 세션 새로고침을 위한 메서드
  Future<Either<Failure, User>> refreshSession() async {
    try {
      final response = await provider.client.auth.refreshSession();
      if (response.session == null) {
        return Left(ServerFailure());
      }

      User user = UserEntity.fromJson(response.user!.toJson()).toModel();
      return Right(user);
    } catch (e) {
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
  Future<Either<Failure, User>> loginInWithEmail(
      String email, String password) async {
    try {
      supabase.AuthResponse response = await provider.client.auth
          .signInWithPassword(email: email, password: password);

      User user = UserEntity.fromJson(response.user!.toJson()).toModel();
      return Right(user);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> loginInWithKakao() async {
    try {
      await provider.client.auth.signInWithOAuth(
        supabase.OAuthProvider.kakao,
        redirectTo: 'com.miro.zippy://oauth',
        authScreenLaunchMode: supabase.LaunchMode.inAppWebView,
      );
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
