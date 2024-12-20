import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/domain/model/app_metadata.model.dart';
import 'package:zippy/domain/model/params/update_app_metadata.params.dart';
import 'package:zippy/domain/usecases/get_app_metadata.usecase.dart';
import 'package:zippy/domain/usecases/update_app_metdata.usecase.dart';

class AppMetadataService extends GetxService {
  final GetAppMetadata _getAppMetadata = Get.find();
  final UpdateAppMetadata _updateAppMetadata = Get.find();

  final Rx<Either<Failure, AppMetadata?>> _state =
      Right<Failure, AppMetadata?>(null).obs;
  final RxBool isLoading = false.obs;

  Either<Failure, AppMetadata?> get state => _state.value;
  AppMetadata? get metadata => _state.value.fold(
        (failure) => null,
        (metadata) => metadata,
      );

  @override
  void onInit() {
    super.onInit();
    _loadMetadata();
  }

  Future<void> _loadMetadata() async {
    isLoading.value = true;
    try {
      final result = await _getAppMetadata.execute();
      _state.value = result;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> getOnBoardingBoardPageStatus() async {
    final currentState = _state.value;

    if (currentState.isRight()) {
      final result = currentState.fold(
        (failure) => false,
        (metadata) => metadata?.onBoardingBoardPage ?? false,
      );
      return result;
    }

    isLoading.value = true;
    try {
      final result = await _getAppMetadata.execute();
      _state.value = result;
      final status = result.fold(
        (failure) => false,
        (metadata) => metadata?.onBoardingBoardPage ?? false,
      );
      return status;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Either<Failure, Unit>> updateOnBoardingBoardPage(
      {bool status = true}) async {
    isLoading.value = true;
    try {
      final updateResult = await _updateAppMetadata
          .execute(UpdateAppMetadataParams(onBoardingBoardPage: status));

      if (updateResult.isRight()) {
        final refreshResult = await _getAppMetadata.execute();
        _state.value = refreshResult;
      } else {
        _state.value = Left((updateResult as Left<Failure, Unit>).value);
      }

      return updateResult;
    } finally {
      isLoading.value = false;
    }
  }
}
