import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/sources/interfaces/item_data_source.dart';
import 'package:zippy/domain/model/item.dart';
import 'package:zippy/domain/model/user_channel.dart';
import 'package:zippy/domain/repositories/interfaces/item_repository.dart';
import 'package:dartz/dartz.dart';

class ItemRepositoryImpl implements ItemRepository {
  final ItemDatasource datasource;

  ItemRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Item>>> getItems() {
    return datasource.getItems();
  }

  @override
  Future<Either<Failure, Item>> getItem(int id) {
    return datasource.getItem(id);
  }

  @override
  Stream<List<Item>> subscribeItems(List<UserChannel> channels) {
    return datasource.subscribeItems(channels);
  }
}
