import 'package:hive/hive.dart';
import 'package:zippy/domain/model/user_bookmark.dart';

part 'user_bookmark_entity.g.dart';

@HiveType(typeId: 0)
class UserBookmarkEntity extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String url;

  @HiveField(3)
  String? contentText;

  @HiveField(4)
  String? contentImgUrl;

  UserBookmarkEntity({
    required this.id,
    required this.title,
    required this.url,
    this.contentText,
    this.contentImgUrl,
  });

  factory UserBookmarkEntity.fromJson(Map<String, dynamic> json) {
    return UserBookmarkEntity(
      id: json["id"],
      title: json["title"],
      url: json["url"],
      contentText: json["contentText"],
      contentImgUrl: json["contentImgUrl"],
    );
  }
  static Map<String, dynamic> toJson(UserBookmarkEntity bookmark) {
    return {
      "id": bookmark.id,
      "title": bookmark.title,
      "url": bookmark.url,
      "contentText": bookmark.contentText,
      "contentImgUrl": bookmark.contentImgUrl
    };
  }

  UserBookmark toModel() {
    return UserBookmark(
        id: id,
        title: title,
        url: url,
        contentText: contentText,
        contentImgUrl: contentImgUrl);
  }

}
