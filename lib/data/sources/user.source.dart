import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user.entity.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/user.model.dart';

String TABLE = 'users';

abstract class UserDatasource {
  Future<Either<Failure, User>> getUser(String id);
}

class UserDatasourceImpl implements UserDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, User>> getUser(String id) async {
    try {
      Map<String, dynamic> response = await provider.client
          .from(TABLE)
          .select('*')
          .eq('id', id)
          .eq('status', true)
          .single();

      User result = UserEntity.fromJson(response).toModel();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
