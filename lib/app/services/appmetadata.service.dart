import 'package:get/get.dart';
import 'package:zippy/domain/model/params/update_app_metadata.params.dart';
import 'package:zippy/domain/usecases/get_app_metadata.usecase.dart';
import 'package:zippy/domain/usecases/update_app_metdata.usecase.dart';

class AppMetadataService extends GetxService {
  final GetAppMetadata getAppMetadata = Get.find();
  final UpdateAppMetadata updateAppMetadata = Get.find();

  Future<bool> onHandleFetchOnBoardingBoardPage() async {
    final result = await getAppMetadata.execute();
    final metadata = result.fold(
      (failure) => null,
      (metadata) => metadata,
    );

    print("fetch metadata: ${metadata?.toJson()}");
    return metadata?.onBoardingBoardPage ?? false;
  }

  Future<void> onHandleUpdateOnBoardingBoardPage() async {
    final result =
        await updateAppMetadata.execute(const UpdateAppMetadataParams(
      onBoardingBoardPage: true,
    ));
    final metadata = result.fold(
      (failure) => null,
      (metadata) => metadata,
    );
    print("update metadata: ${metadata?.toJson()}");
  }
}
