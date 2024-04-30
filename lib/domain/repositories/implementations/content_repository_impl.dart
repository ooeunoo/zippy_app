import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/sources/interfaces/content_data_source.dart';
import 'package:zippy/domain/model/content.dart';
import 'package:zippy/domain/model/user_category.dart';
import 'package:zippy/domain/repositories/interfaces/content_repository.dart';
import 'package:dartz/dartz.dart';

class ContentRepositoryImpl implements ContentRepository {
  final ContentDatasource datasource;

  ContentRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Content>>> getContents() {
    return datasource.getContents();
  }

  @override
  Future<Either<Failure, Content>> getContent(int id) {
    return datasource.getContent(id);
  }

  @override
  Stream<List<Content>> subscribeContents(List<UserCategory> categories) {
    return datasource.subscribeContents(categories);
  }
}
