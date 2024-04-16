// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PageInfo _$PageInfoFromJson(Map<String, dynamic> json) {
  return _PageInfo.fromJson(json);
}

/// @nodoc
mixin _$PageInfo {
  int get max => throw _privateConstructorUsedError;
  int get view => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PageInfoCopyWith<PageInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageInfoCopyWith<$Res> {
  factory $PageInfoCopyWith(PageInfo value, $Res Function(PageInfo) then) =
      _$PageInfoCopyWithImpl<$Res, PageInfo>;
  @useResult
  $Res call({int max, int view});
}

/// @nodoc
class _$PageInfoCopyWithImpl<$Res, $Val extends PageInfo>
    implements $PageInfoCopyWith<$Res> {
  _$PageInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? max = null,
    Object? view = null,
  }) {
    return _then(_value.copyWith(
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as int,
      view: null == view
          ? _value.view
          : view // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PageInfoImplCopyWith<$Res>
    implements $PageInfoCopyWith<$Res> {
  factory _$$PageInfoImplCopyWith(
          _$PageInfoImpl value, $Res Function(_$PageInfoImpl) then) =
      __$$PageInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int max, int view});
}

/// @nodoc
class __$$PageInfoImplCopyWithImpl<$Res>
    extends _$PageInfoCopyWithImpl<$Res, _$PageInfoImpl>
    implements _$$PageInfoImplCopyWith<$Res> {
  __$$PageInfoImplCopyWithImpl(
      _$PageInfoImpl _value, $Res Function(_$PageInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? max = null,
    Object? view = null,
  }) {
    return _then(_$PageInfoImpl(
      max: null == max
          ? _value.max
          : max // ignore: cast_nullable_to_non_nullable
              as int,
      view: null == view
          ? _value.view
          : view // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PageInfoImpl implements _PageInfo {
  const _$PageInfoImpl({required this.max, required this.view});

  factory _$PageInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PageInfoImplFromJson(json);

  @override
  final int max;
  @override
  final int view;

  @override
  String toString() {
    return 'PageInfo(max: $max, view: $view)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageInfoImpl &&
            (identical(other.max, max) || other.max == max) &&
            (identical(other.view, view) || other.view == view));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, max, view);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PageInfoImplCopyWith<_$PageInfoImpl> get copyWith =>
      __$$PageInfoImplCopyWithImpl<_$PageInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PageInfoImplToJson(
      this,
    );
  }
}

abstract class _PageInfo implements PageInfo {
  const factory _PageInfo({required final int max, required final int view}) =
      _$PageInfoImpl;

  factory _PageInfo.fromJson(Map<String, dynamic> json) =
      _$PageInfoImpl.fromJson;

  @override
  int get max;
  @override
  int get view;
  @override
  @JsonKey(ignore: true)
  _$$PageInfoImplCopyWith<_$PageInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PosInfo _$PosInfoFromJson(Map<String, dynamic> json) {
  return _PosInfo.fromJson(json);
}

/// @nodoc
mixin _$PosInfo {
  int get index => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PosInfoCopyWith<PosInfo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PosInfoCopyWith<$Res> {
  factory $PosInfoCopyWith(PosInfo value, $Res Function(PosInfo) then) =
      _$PosInfoCopyWithImpl<$Res, PosInfo>;
  @useResult
  $Res call({int index, bool loading});
}

/// @nodoc
class _$PosInfoCopyWithImpl<$Res, $Val extends PosInfo>
    implements $PosInfoCopyWith<$Res> {
  _$PosInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? loading = null,
  }) {
    return _then(_value.copyWith(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PosInfoImplCopyWith<$Res> implements $PosInfoCopyWith<$Res> {
  factory _$$PosInfoImplCopyWith(
          _$PosInfoImpl value, $Res Function(_$PosInfoImpl) then) =
      __$$PosInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int index, bool loading});
}

/// @nodoc
class __$$PosInfoImplCopyWithImpl<$Res>
    extends _$PosInfoCopyWithImpl<$Res, _$PosInfoImpl>
    implements _$$PosInfoImplCopyWith<$Res> {
  __$$PosInfoImplCopyWithImpl(
      _$PosInfoImpl _value, $Res Function(_$PosInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? loading = null,
  }) {
    return _then(_$PosInfoImpl(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PosInfoImpl implements _PosInfo {
  const _$PosInfoImpl({required this.index, required this.loading});

  factory _$PosInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PosInfoImplFromJson(json);

  @override
  final int index;
  @override
  final bool loading;

  @override
  String toString() {
    return 'PosInfo(index: $index, loading: $loading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PosInfoImpl &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.loading, loading) || other.loading == loading));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, index, loading);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PosInfoImplCopyWith<_$PosInfoImpl> get copyWith =>
      __$$PosInfoImplCopyWithImpl<_$PosInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PosInfoImplToJson(
      this,
    );
  }
}

abstract class _PosInfo implements PosInfo {
  const factory _PosInfo(
      {required final int index, required final bool loading}) = _$PosInfoImpl;

  factory _PosInfo.fromJson(Map<String, dynamic> json) = _$PosInfoImpl.fromJson;

  @override
  int get index;
  @override
  bool get loading;
  @override
  @JsonKey(ignore: true)
  _$$PosInfoImplCopyWith<_$PosInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
