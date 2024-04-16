import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_info.freezed.dart';
part 'page_info.g.dart';

@freezed
class PageInfo with _$PageInfo {
  const factory PageInfo({
    required int max,
    required int view,
  }) = _PageInfo;

  factory PageInfo.fromJson(Map<String, dynamic> json) =>
      _$PageInfoFromJson(json);
}

@freezed
class PosInfo with _$PosInfo {
  const factory PosInfo({required int index, required bool loading}) = _PosInfo;

  factory PosInfo.fromJson(Map<String, dynamic> json) =>
      _$PosInfoFromJson(json);
}
