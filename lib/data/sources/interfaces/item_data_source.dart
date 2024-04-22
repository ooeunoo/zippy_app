import 'dart:async';

import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/category_entity.dart';
import 'package:zippy/domain/model/category.dart';
import 'package:zippy/domain/model/item.dart';
import "package:dartz/dartz.dart";

abstract class ItemDatasource {
  Future<Either<Failure, List<Item>>> getItems();
  Future<Either<Failure, Item>> getItem(int id);
  Stream<List<Item>> subscribeItems();
}
