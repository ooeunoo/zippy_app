import 'package:cocomu/app/failures/failure.dart';
import 'package:cocomu/domain/model/item.dart';
import 'package:dartz/dartz.dart';

abstract class ItemRepository {
  Future<Either<Failure, List<Item>>> getItems();
  Future<Either<Failure, Item>> getItem(int id);
  Stream<List<Item>> subscribeItems();
}
