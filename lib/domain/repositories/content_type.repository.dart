import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/sources/content_type.source.dart';
import 'package:dartz/dartz.dart';
import 'package:zippy/domain/model/content_type.model.dart';

abstract class ContentTypeRepository {
  Future<Either<Failure, List<ContentType>>> getContentTypes();
}

class ContentTypeRepositoryImpl implements ContentTypeRepository {
  final ContentTypeDatasource datasource;

  ContentTypeRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<ContentType>>> getContentTypes() {
    return datasource.getContentTypes();
  }
}
