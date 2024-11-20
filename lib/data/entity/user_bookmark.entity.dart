import 'package:hive/hive.dart';
import 'package:zippy/app/utils/constants.dart';
import 'package:zippy/domain/model/user_bookmark.model.dart';

part 'user_bookmark.entity.g.dart';

@HiveType(typeId: Constants.userBookmarkHiveId)
class UserBookmarkEntity extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String link;

  @HiveField(3)
  String? images;

  @HiveField(4)
  String folderId;

  UserBookmarkEntity({
    required this.id,
    required this.title,
    required this.link,
    this.images,
    required this.folderId,
  });

  factory UserBookmarkEntity.fromJson(Map<String, dynamic> json) {
    return UserBookmarkEntity(
      id: json["id"],
      title: json["title"],
      link: json["link"],
      images: json["images"],
      folderId: json["folder_id"],
    );
  }
  static Map<String, dynamic> toJson(UserBookmarkEntity bookmark) {
    return {
      "id": bookmark.id,
      "title": bookmark.title,
      "link": bookmark.link,
      "images": bookmark.images,
      "folder_id": bookmark.folderId,
    };
  }

  UserBookmark toModel() {
    return UserBookmark(
      id: id,
      title: title,
      link: link,
      images: images,
      folderId: folderId,
    );
  }
}
