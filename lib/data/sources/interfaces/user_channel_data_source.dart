import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/bookmark_entity.dart';
import 'package:zippy/data/entity/user_channel_entity.dart';
import 'package:zippy/domain/model/bookmark.dart';
import "package:dartz/dartz.dart";
import 'package:zippy/domain/model/user_channel.dart';

abstract class UserChannelDatasource {
  Future<Either<Failure, List<UserChannel>>> getUserChannels(String userId);
  Future<Either<Failure, bool>> createUserChannel(
      List<UserChannelEntity> channels);
  Future<Either<Failure, bool>> deleteUserChannel(
      List<UserChannelEntity> channels);
}
