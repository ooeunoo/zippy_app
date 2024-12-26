import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user.entity.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/user.model.dart';

String TABLE = 'users';

abstract class UserDatasource {
  Future<Either<Failure, User?>> getUser(String id);
  Future<Either<Failure, bool>> updateFcmToken(String id, String token);
}

class UserDatasourceImpl implements UserDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, User?>> getUser(String id) async {
    try {
      Map<String, dynamic>? response = await provider.client
          .from(TABLE)
          .select('*')
          .eq('id', id)
          .maybeSingle();

      User? result =
          response != null ? UserEntity.fromJson(response).toModel() : null;
      return Right(result);
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateFcmToken(String id, String token) async {
    try {
      final currentUserId = provider.client.auth.currentUser?.id;
      print('Current user ID: $currentUserId');
      print('Updating user ID: $id');

      if (currentUserId == null) {
        print('User not authenticated');
        return Left(ServerFailure());
      }

      await provider.client.from(TABLE).update({
        'fcm_token': token,
      }).eq('id', id);

      return const Right(true);
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }
}
