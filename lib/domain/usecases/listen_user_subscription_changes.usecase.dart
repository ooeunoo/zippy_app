import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zippy/domain/repositories/user_category.repository.dart';

class ListenUserSubscriptionChanges {
  final UserSubscriptionRepository repo;

  ListenUserSubscriptionChanges(this.repo);

  RealtimeChannel execute(String userId, VoidCallback callback) {
    return repo.listenUserSubscriptionChanges(userId, callback);
  }
}
