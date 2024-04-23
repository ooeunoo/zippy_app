import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/user_channel_entity.dart';
import 'package:zippy/data/sources/interfaces/user_channel_data_source.dart';
import 'package:zippy/domain/model/user_channel.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/interfaces/user_channel_repository.dart';

class UserChannelRepositoryImpl implements UserChannelRepository {
  final UserChannelDatasource datasource;

  UserChannelRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<UserChannel>>> getUserChannelByUserId(
      String userId) {
    return datasource.getUserChannels(userId);
  }

  @override
  Future<Either<Failure, bool>> createUserChannel(
      List<UserChannelEntity> channels) {
    return datasource.createUserChannel(channels);
  }

  @override
  Future<Either<Failure, bool>> deleteUserChannel(
      List<UserChannelEntity> channels) {
    return datasource.deleteUserChannel(channels);
  }

  @override
  Stream<List<UserChannel>> subscribeUserChannel(String userId) {
    return datasource.subscribeUserChannel(userId);
  }
}
