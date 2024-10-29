import 'package:hive/hive.dart';
import 'package:zippy/app/utils/constants.dart';
import 'package:zippy/domain/model/app_metadata.model.dart';

part 'app_metadata.entity.g.dart';

@HiveType(typeId: Constants.appMetadataHiveId)
class AppMetadataEntity extends HiveObject {
  @HiveField(0)
  bool lookaround;

  AppMetadataEntity({
    required this.lookaround,
  });

  AppMetadata toModel() {
    return AppMetadata(lookaround: lookaround);
  }
}
