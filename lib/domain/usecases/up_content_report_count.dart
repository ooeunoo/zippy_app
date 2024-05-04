import 'package:dartz/dartz.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/repositories/interfaces/content_repository.dart';

class UpContentReportCount {
  final ContentRepository repo;

  UpContentReportCount(this.repo);

  Future<void> execute(int id) {
    return repo.upContentReportCount(id);
  }
}
