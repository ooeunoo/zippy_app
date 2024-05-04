import 'dart:async';

import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/category_entity.dart';
import 'package:zippy/domain/model/category.dart';
import 'package:zippy/domain/model/content.dart';
import "package:dartz/dartz.dart";
import 'package:zippy/domain/model/user_category.dart';

abstract class ContentDatasource {
  Future<Either<Failure, List<Content>>> getContents();
  Future<Either<Failure, Content>> getContent(int id);
  Stream<List<Content>> subscribeContents(List<UserCategory> categories);
  Future<void> upContentViewCount(int id);
  Future<void> upContentReportCount(int id);
}
