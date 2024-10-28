import 'package:hive/hive.dart';
import 'package:zippy/domain/model/user_subscription.model.dart';

part 'user_subscription.entity.g.dart';

@HiveType(typeId: 1)
class UserSubscriptionEntity extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  int platformId;

  UserSubscriptionEntity({
    required this.id,
    required this.platformId,
  });

  UserSubscription toModel() {
    return UserSubscription(id: id, platformId: platformId);
  }
}
