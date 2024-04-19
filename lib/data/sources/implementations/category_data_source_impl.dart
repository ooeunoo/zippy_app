// ignore_for_file: non_constant_identifier_names

import 'package:cocomu/app/failures/failure.dart';
import 'package:cocomu/data/entity/category_entity.dart';
import 'package:cocomu/data/providers/supabase_provider.dart';
import 'package:cocomu/data/sources/interfaces/category_data_source.dart';
import 'package:cocomu/domain/model/category.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

String TABLE = 'category';

class CategoryDatasourceIml implements CategoryDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      List<Map<String, dynamic>> response =
          await provider.client.from(TABLE).select('*');

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
      Map<String, dynamic> response =
          await provider.client.from(TABLE).select('*').eq('id', id).single();

      Category result = CategoryEntity.fromJson(response).toModel();

      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
