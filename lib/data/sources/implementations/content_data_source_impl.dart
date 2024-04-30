// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/item_entity.dart';
import 'package:zippy/data/providers/supabase_provider.dart';
import 'package:zippy/data/sources/interfaces/content_data_source.dart';
import 'package:zippy/domain/model/content.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/user_category.dart';

String TABLE = 'content';

class ContentDatasourceImpl implements ContentDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, List<Content>>> getContents() async {
    try {
      List<Map<String, dynamic>> response =
          await provider.client.from(TABLE).select('*');

      List<Content> result =
          response.map((r) => ItemEntity.fromJson(r).toModel()).toList();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Content>> getContent(int id) async {
    try {
      Map<String, dynamic> response =
          await provider.client.from(TABLE).select('*').eq('id', id).single();

      Content result = ItemEntity.fromJson(response).toModel();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Stream<List<Content>> subscribeContents(List<UserCategory> categories) {
    List<int> categoryIds = [];
    for (UserCategory category in categories) {
      categoryIds.add(category.id);
    }
    return provider.client
        .from(TABLE)
        .stream(primaryKey: ['id'])
        .inFilter('category_id', categoryIds)
        .order('created_at', ascending: false)
        .map((data) => data.map((item) {
              return ItemEntity.fromJson(item).toModel();
            }).toList());
  }
}
