import 'dart:async';

import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/params/create_user_feedback.params.dart';

String TABLE = 'user_feedbacks';

abstract class UserFeedbackDatasource {
  Future<Either<Failure, bool>> createUserFeedback(
      CreateUserFeedbackParams params);
}

class UserFeedbackDatasourceImpl implements UserFeedbackDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, bool>> createUserFeedback(
      CreateUserFeedbackParams params) async {
    try {
      await provider.client.from(TABLE).insert(params.toJson());
      return const Right(true);
    } catch (e, stackTrace) {
      print('Error:$e \n stackTrace:$stackTrace');
      return Left(ServerFailure());
    }
  }
}
