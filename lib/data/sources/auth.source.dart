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
  Stream<User?> authStateChanges();
  Future<void> signOut();
  bool isAuthenticated();
  Future<Either<Failure, User>> loginInWithEmail(String email, String password);
}

class AuthDatasourceImpl implements AuthDatasource {
  SupabaseProvider provider = Get.find();
  UserDatasource userDatasource = Get.find();

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final currentUser = provider.client.auth.currentUser;
      print(currentUser);
      if (currentUser == null) {
        return const Right(null);
      }

      User user = UserEntity.fromJson(currentUser.toJson()).toModel();
      return Right(user);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Stream<User?> authStateChanges() {
    return provider.client.auth.onAuthStateChange.map((event) {
      final authUser = event.session?.user;
      if (authUser == null) {
        return null;
      }
      return UserEntity.fromJson(authUser.toJson()).toModel();
    });
  }

  @override
  Future<void> signOut() async {
    try {
      await provider.client.auth.signOut();
    } catch (e) {
      throw ServerFailure();
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
}
