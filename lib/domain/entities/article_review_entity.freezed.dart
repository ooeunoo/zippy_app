// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'article_review_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ArticleReviewEntity _$ArticleReviewEntityFromJson(Map<String, dynamic> json) {
  return _ArticleReviewEntity.fromJson(json);
}

/// @nodoc
mixin _$ArticleReviewEntity {
  String get reviewer => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<ArticleReviewEntity>? get subReviews =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ArticleReviewEntityCopyWith<ArticleReviewEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArticleReviewEntityCopyWith<$Res> {
  factory $ArticleReviewEntityCopyWith(
          ArticleReviewEntity value, $Res Function(ArticleReviewEntity) then) =
      _$ArticleReviewEntityCopyWithImpl<$Res, ArticleReviewEntity>;
  @useResult
  $Res call(
      {String reviewer,
      String content,
      DateTime createdAt,
      List<ArticleReviewEntity>? subReviews});
}

/// @nodoc
class _$ArticleReviewEntityCopyWithImpl<$Res, $Val extends ArticleReviewEntity>
    implements $ArticleReviewEntityCopyWith<$Res> {
  _$ArticleReviewEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reviewer = null,
    Object? content = null,
    Object? createdAt = null,
    Object? subReviews = freezed,
  }) {
    return _then(_value.copyWith(
      reviewer: null == reviewer
          ? _value.reviewer
          : reviewer // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      subReviews: freezed == subReviews
          ? _value.subReviews
          : subReviews // ignore: cast_nullable_to_non_nullable
              as List<ArticleReviewEntity>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ArticleReviewEntityImplCopyWith<$Res>
    implements $ArticleReviewEntityCopyWith<$Res> {
  factory _$$ArticleReviewEntityImplCopyWith(_$ArticleReviewEntityImpl value,
          $Res Function(_$ArticleReviewEntityImpl) then) =
      __$$ArticleReviewEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String reviewer,
      String content,
      DateTime createdAt,
      List<ArticleReviewEntity>? subReviews});
}

/// @nodoc
class __$$ArticleReviewEntityImplCopyWithImpl<$Res>
    extends _$ArticleReviewEntityCopyWithImpl<$Res, _$ArticleReviewEntityImpl>
    implements _$$ArticleReviewEntityImplCopyWith<$Res> {
  __$$ArticleReviewEntityImplCopyWithImpl(_$ArticleReviewEntityImpl _value,
      $Res Function(_$ArticleReviewEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reviewer = null,
    Object? content = null,
    Object? createdAt = null,
    Object? subReviews = freezed,
  }) {
    return _then(_$ArticleReviewEntityImpl(
      reviewer: null == reviewer
          ? _value.reviewer
          : reviewer // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      subReviews: freezed == subReviews
          ? _value._subReviews
          : subReviews // ignore: cast_nullable_to_non_nullable
              as List<ArticleReviewEntity>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ArticleReviewEntityImpl implements _ArticleReviewEntity {
  const _$ArticleReviewEntityImpl(
      {required this.reviewer,
      required this.content,
      required this.createdAt,
      final List<ArticleReviewEntity>? subReviews})
      : _subReviews = subReviews;

  factory _$ArticleReviewEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArticleReviewEntityImplFromJson(json);

  @override
  final String reviewer;
  @override
  final String content;
  @override
  final DateTime createdAt;
  final List<ArticleReviewEntity>? _subReviews;
  @override
  List<ArticleReviewEntity>? get subReviews {
    final value = _subReviews;
    if (value == null) return null;
    if (_subReviews is EqualUnmodifiableListView) return _subReviews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ArticleReviewEntity(reviewer: $reviewer, content: $content, createdAt: $createdAt, subReviews: $subReviews)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArticleReviewEntityImpl &&
            (identical(other.reviewer, reviewer) ||
                other.reviewer == reviewer) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality()
                .equals(other._subReviews, _subReviews));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, reviewer, content, createdAt,
      const DeepCollectionEquality().hash(_subReviews));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ArticleReviewEntityImplCopyWith<_$ArticleReviewEntityImpl> get copyWith =>
      __$$ArticleReviewEntityImplCopyWithImpl<_$ArticleReviewEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArticleReviewEntityImplToJson(
      this,
    );
  }
}

abstract class _ArticleReviewEntity implements ArticleReviewEntity {
  const factory _ArticleReviewEntity(
      {required final String reviewer,
      required final String content,
      required final DateTime createdAt,
      final List<ArticleReviewEntity>? subReviews}) = _$ArticleReviewEntityImpl;

  factory _ArticleReviewEntity.fromJson(Map<String, dynamic> json) =
      _$ArticleReviewEntityImpl.fromJson;

  @override
  String get reviewer;
  @override
  String get content;
  @override
  DateTime get createdAt;
  @override
  List<ArticleReviewEntity>? get subReviews;
  @override
  @JsonKey(ignore: true)
  _$$ArticleReviewEntityImplCopyWith<_$ArticleReviewEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
