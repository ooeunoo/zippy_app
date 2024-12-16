import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zippy/app/failures/failure.dart';
import 'package:zippy/data/entity/app_metadata.entity.dart';
import 'package:zippy/data/providers/hive.provider.dart';
import 'package:zippy/domain/model/app_metadata.model.dart';
import 'package:zippy/domain/model/params/update_app_metadata.params.dart';

abstract class AppMetadataDataSource {
  Future<Either<Failure, AppMetadata?>> getAppMetadata();
  Future<Either<Failure, Unit>> saveAppMetadata(AppMetadata metadata);
  Future<Either<Failure, Unit>> updateAppMetadata(
      UpdateAppMetadataParams params);
  Future<Either<Failure, Unit>> clearAppMetadata();
}

class AppMetadataDataSourceImpl implements AppMetadataDataSource {
  final HiveProvider hiveProvider;

  AppMetadataDataSourceImpl({required this.hiveProvider});

  @override
  Future<Either<Failure, AppMetadata?>> getAppMetadata() async {
    try {
      await _ensureBoxOpen();

      final entity =
          hiveProvider.appMetadata?.get('metadata') as AppMetadataEntity?;
      final model = entity?.toModel();

      return Right(model);
    } catch (e, stackTrace) {
      print('Error getting app metadata: $e\nStackTrace: $stackTrace');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> saveAppMetadata(AppMetadata metadata) async {
    try {
      await _ensureBoxOpen();

      final entity = AppMetadataEntity(
        lookaround: metadata.lookaround,
        themeMode: metadata.themeMode.toString().split('.').last.toLowerCase(),
        onBoardingBoardPage: metadata.onBoardingBoardPage,
        onBoardingBookmarkPage: metadata.onBoardingBookmarkPage,
      );

      await hiveProvider.appMetadata?.put('metadata', entity);
      return const Right(unit);
    } catch (e, stackTrace) {
      print('Error saving app metadata: $e\nStackTrace: $stackTrace');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateAppMetadata(
      UpdateAppMetadataParams params) async {
    try {
      await _ensureBoxOpen();

      // 현재 저장된 메타데이터 가져오기
      final currentEntity =
          hiveProvider.appMetadata?.get('metadata') as AppMetadataEntity?;
      final currentMetadata = currentEntity?.toModel();

      // 새로운 메타데이터 생성 (기존 값 유지하면서 업데이트)
      final updatedMetadata = AppMetadata(
        lookaround: params.lookaround ?? currentMetadata?.lookaround ?? false,
        themeMode:
            params.themeMode ?? currentMetadata?.themeMode ?? ThemeMode.system,
        onBoardingBoardPage: params.onBoardingBoardPage ??
            currentMetadata?.onBoardingBoardPage ??
            false,
        onBoardingBookmarkPage: params.onBoardingBookmarkPage ??
            currentMetadata?.onBoardingBookmarkPage ??
            false,
      );

      // 엔티티로 변환하여 저장
      final entity = AppMetadataEntity(
        lookaround: updatedMetadata.lookaround,
        themeMode:
            updatedMetadata.themeMode.toString().split('.').last.toLowerCase(),
        onBoardingBoardPage: updatedMetadata.onBoardingBoardPage,
        onBoardingBookmarkPage: updatedMetadata.onBoardingBookmarkPage,
      );

      await hiveProvider.appMetadata?.put('metadata', entity);
      return const Right(unit);
    } catch (e, stackTrace) {
      print('Error updating app metadata: $e\nStackTrace: $stackTrace');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> clearAppMetadata() async {
    try {
      await _ensureBoxOpen();
      await hiveProvider.appMetadata?.delete('metadata');
      return const Right(unit);
    } catch (e, stackTrace) {
      print('Error clearing app metadata: $e\nStackTrace: $stackTrace');
      return Left(CacheFailure());
    }
  }

  // Helper method to ensure box is open
  Future<void> _ensureBoxOpen() async {
    if (hiveProvider.appMetadata == null || !hiveProvider.appMetadata!.isOpen) {
      await hiveProvider.openBox();
    }
  }
}
