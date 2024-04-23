// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/item_entity.dart';
import 'package:zippy/data/providers/supabase_provider.dart';
import 'package:zippy/data/sources/interfaces/item_data_source.dart';
import 'package:zippy/domain/model/item.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/user_channel.dart';

String TABLE = 'item';

class ItemDatasourceImpl implements ItemDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, List<Item>>> getItems() async {
    try {
      List<Map<String, dynamic>> response =
          await provider.client.from(TABLE).select('*');

      List<Item> result =
          response.map((r) => ItemEntity.fromJson(r).toModel()).toList();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Item>> getItem(int id) async {
    try {
      Map<String, dynamic> response =
          await provider.client.from(TABLE).select('*').eq('id', id).single();

      Item result = ItemEntity.fromJson(response).toModel();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Stream<List<Item>> subscribeItems(List<UserChannel> channels) {
    List<int> categoryIds = [];
    for (UserChannel channel in channels) {
      categoryIds.add(channel.categoryId);
    }

    return provider.client
        .from(TABLE)
        .stream(primaryKey: ['id'])
        .inFilter('category_id', categoryIds)
        .order('created_at', ascending: false) // Ascending order
        // .limit(2)
        .map((data) => data.map((item) {
              return ItemEntity.fromJson(item).toModel();
            }).toList());
  }
}
