import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/content.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/user_category.dart';

abstract class ContentRepository {
  Future<Either<Failure, List<Content>>> getContents();
  Future<Either<Failure, Content>> getContent(int id);
  Stream<List<Content>> subscribeContents(List<UserCategory> categories);
}
