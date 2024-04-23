import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_channel_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/user_channel.dart';

abstract class UserChannelRepository {
  Future<Either<Failure, List<UserChannel>>> getUserChannelByUserId(
      String userId);
  Future<Either<Failure, bool>> createUserChannel(
      List<UserChannelEntity> channels);
  Future<Either<Failure, bool>> deleteUserChannel(
      List<UserChannelEntity> channels);
}
