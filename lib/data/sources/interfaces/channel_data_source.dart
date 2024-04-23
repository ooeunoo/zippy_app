import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/channel.dart';
import "package:dartz/dartz.dart";

abstract class ChannelDatasource {
  Future<Either<Failure, List<Channel>>> getChannels();
  Future<Either<Failure, Channel>> getChannel(int id);
}
