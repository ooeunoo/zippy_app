import 'package:hive/hive.dart';
import 'package:zippy/domain/model/user_category.dart';

part 'user_category_entity.g.dart';

@HiveType(typeId: 1)
class UserCategoryEntity extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  int channelId;

  @HiveField(2)
  String name;

  UserCategoryEntity({
    required this.id,
    required this.channelId,
    required this.name,
  });

  UserCategory toModel() {
    return UserCategory(id: id, channelId: channelId, name: name);
  }
}
