import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:zippy/domain/model/user.model.dart';
import 'package:zippy/domain/repositories/auth.repository.dart';

class SubscribeAuthStatus {
  final AuthRepository repo;

  SubscribeAuthStatus(this.repo);

  Stream<Tuple2<supabase.AuthChangeEvent, User?>> execute() {
    return repo.subscribeAuthStatus();
  }
}
