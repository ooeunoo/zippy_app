import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/channel.dart';
import 'package:zippy/domain/model/content.dart';
import 'package:zippy/domain/model/params/get_contents_params.dart';
import 'package:zippy/domain/repositories/interfaces/channel_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/repositories/interfaces/content_repository.dart';

class GetContents {
  final ContentRepository repo;

  GetContents(this.repo);

  Future<Either<Failure, List<Content>>> execute(GetContentsParams params) {
    return repo.getContents(params);
  }
}
