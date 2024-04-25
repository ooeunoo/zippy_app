import 'package:zippy/domain/model/content.dart';
import 'package:zippy/domain/repositories/interfaces/item_repository.dart';
import 'package:zippy/domain/repositories/interfaces/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubscribeUser {
  final UserRepository repo;

  SubscribeUser(this.repo);

  Stream<User?> execute() {
    return repo.subscribeUser();
  }
}
