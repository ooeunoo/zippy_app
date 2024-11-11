import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';

@immutable
class GetArticlesParams extends Equatable {
  final List<UserSubscription>? subscriptions;
  final int limit;

  const GetArticlesParams({
    this.subscriptions,
    this.limit = 1000,
  });

  @override
  List<Object> get props {
    return [];
  }

  Map<String, dynamic> toJson() =>
      {'limit': limit, 'subscriptions': subscriptions};

  @override
  String toString() {
    return toJson().toString();
  }
}
