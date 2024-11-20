// 2. 폴더 Hive 엔티티 (bookmark_folder.entity.dart)
import 'package:hive/hive.dart';
import 'package:zippy/app/utils/constants.dart';
import 'package:zippy/domain/model/user_bookmark_folder.model.dart';

part 'user_bookmark_folder.entity.g.dart';

@HiveType(typeId: Constants.userBookmarkFolderHiveId)
class UserBookmarkFolderEntity extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(2)
  String name;

  @HiveField(3)
  String? description;

  @HiveField(4)
  DateTime createdAt;

  UserBookmarkFolderEntity({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
  });

  factory UserBookmarkFolderEntity.fromJson(Map<String, dynamic> json) {
    return UserBookmarkFolderEntity(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      createdAt: DateTime.parse(json["created_at"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "created_at": createdAt.toIso8601String(),
    };
  }

  UserBookmarkFolder toModel() {
    return UserBookmarkFolder(
      id: id,
      name: name,
      description: description,
      createdAt: createdAt,
    );
  }
}
