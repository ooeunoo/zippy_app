import 'package:zippy/data/sources/user.source.dart';

abstract class UserRepository {}

class UserRepositoryImpl implements UserRepository {
  final UserDatasource datasource;

  UserRepositoryImpl(this.datasource);
}
