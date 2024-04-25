import 'dart:async';

import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/category_entity.dart';
import 'package:zippy/domain/model/category.dart';
import 'package:zippy/domain/model/content.dart';
import "package:dartz/dartz.dart";
import 'package:zippy/domain/model/user_channel.dart';

abstract class ItemDatasource {
  Future<Either<Failure, List<Content>>> getItems();
  Future<Either<Failure, Content>> getItem(int id);
  Stream<List<Content>> subscribeItems(List<UserChannel> channels);
}
