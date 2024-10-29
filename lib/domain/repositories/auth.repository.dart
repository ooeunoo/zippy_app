import 'package:zippy/data/sources/auth.source.dart';

abstract class AuthRepository {
  // Future<Either<Failure, bool>> loginWithKakao();
  // Future<Either<Failure, bool>> loginWithGoogle();
  // Future<Either<Failure, bool>> loginWithApple();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);
}
