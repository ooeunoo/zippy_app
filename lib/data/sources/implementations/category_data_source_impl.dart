// ignore_for_file: non_constant_identifier_names

import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/category_entity.dart';
import 'package:zippy/data/providers/supabase_provider.dart';
import 'package:zippy/data/sources/interfaces/category_data_source.dart';
import 'package:zippy/domain/model/category.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

String TABLE = 'category';

class CategoryDatasourceIml implements CategoryDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, List<Category>>> getCategories(
      {String? channelId}) async {
    try {
      Map<String, dynamic> where = {};

      if (channelId != null) {
        where['channel_id'] = channelId;
      }

      List<Map<String, dynamic>> response = await provider.client
          .from(TABLE)
          .select('*')
          .eq('status', true)
          .match(where);

      List<Category> result =
          response.map((r) => CategoryEntity.fromJson(r).toModel()).toList();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Category>> getCategory(int id) async {
    try {
      Map<String, dynamic> response = await provider.client
          .from(TABLE)
          .select('*')
          .eq('id', id)
          .eq('status', true)
          .single();

      Category result = CategoryEntity.fromJson(response).toModel();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
