import 'package:zippy/domain/model/user.model.dart';
import 'package:zippy/domain/repositories/auth.repository.dart';

class SubscribeAuthStatus {
  final AuthRepository repo;

  SubscribeAuthStatus(this.repo);

  Stream<User?> execute() {
    return repo.subscribeAuthStatus();
  }
}
