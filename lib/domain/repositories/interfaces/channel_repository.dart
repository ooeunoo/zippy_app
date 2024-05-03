import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/channel.dart';
import 'package:dartz/dartz.dart';

abstract class ChannelRepository {
  Future<Either<Failure, List<Channel>>> getChannels(
      {bool withCategory = false});
  Future<Either<Failure, Channel>> getChannel(int id);
}
