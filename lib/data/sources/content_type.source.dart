import 'dart:async';

import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/cotent_type.entity.dart';
import 'package:zippy/data/providers/supabase.provider.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/domain/model/content_type.model.dart';

String TABLE = 'content_types';

abstract class ContentTypeDatasource {
  Future<Either<Failure, List<ContentType>>> getContentTypes();
}

class ContentTypeDatasourceImpl implements ContentTypeDatasource {
  SupabaseProvider provider = Get.find();

  @override
  Future<Either<Failure, List<ContentType>>> getContentTypes() async {
    try {
      List<Map<String, dynamic>> response =
          await provider.client.from(TABLE).select('*');

      List<ContentType> result =
          response.map((r) => ContentTypeEntity.fromJson(r).toModel()).toList();

      return Right(result);
    } catch (e) {
      print(e);
      return Left(ServerFailure());
    }
  }
}
