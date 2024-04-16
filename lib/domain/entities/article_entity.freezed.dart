// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'article_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ArticleEntity _$ArticleEntityFromJson(Map<String, dynamic> json) {
  return _ArticleEntity.fromJson(json);
}

/// @nodoc
mixin _$ArticleEntity {
  Community get community => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<ArticleReviewEntity>? get reviews => throw _privateConstructorUsedError;
  int get numViews => throw _privateConstructorUsedError;
  int get numRecommendations => throw _privateConstructorUsedError;
  int get numReviews => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ArticleEntityCopyWith<ArticleEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArticleEntityCopyWith<$Res> {
  factory $ArticleEntityCopyWith(
          ArticleEntity value, $Res Function(ArticleEntity) then) =
      _$ArticleEntityCopyWithImpl<$Res, ArticleEntity>;
  @useResult
  $Res call(
      {Community community,
      String title,
      String author,
      String content,
      List<ArticleReviewEntity>? reviews,
      int numViews,
      int numRecommendations,
      int numReviews,
      DateTime createdAt});
}

/// @nodoc
class _$ArticleEntityCopyWithImpl<$Res, $Val extends ArticleEntity>
    implements $ArticleEntityCopyWith<$Res> {
  _$ArticleEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? community = null,
    Object? title = null,
    Object? author = null,
    Object? content = null,
    Object? reviews = freezed,
    Object? numViews = null,
    Object? numRecommendations = null,
    Object? numReviews = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      community: null == community
          ? _value.community
          : community // ignore: cast_nullable_to_non_nullable
              as Community,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      reviews: freezed == reviews
          ? _value.reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as List<ArticleReviewEntity>?,
      numViews: null == numViews
          ? _value.numViews
          : numViews // ignore: cast_nullable_to_non_nullable
              as int,
      numRecommendations: null == numRecommendations
          ? _value.numRecommendations
          : numRecommendations // ignore: cast_nullable_to_non_nullable
              as int,
      numReviews: null == numReviews
          ? _value.numReviews
          : numReviews // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ArticleEntityImplCopyWith<$Res>
    implements $ArticleEntityCopyWith<$Res> {
  factory _$$ArticleEntityImplCopyWith(
          _$ArticleEntityImpl value, $Res Function(_$ArticleEntityImpl) then) =
      __$$ArticleEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Community community,
      String title,
      String author,
      String content,
      List<ArticleReviewEntity>? reviews,
      int numViews,
      int numRecommendations,
      int numReviews,
      DateTime createdAt});
}

/// @nodoc
class __$$ArticleEntityImplCopyWithImpl<$Res>
    extends _$ArticleEntityCopyWithImpl<$Res, _$ArticleEntityImpl>
    implements _$$ArticleEntityImplCopyWith<$Res> {
  __$$ArticleEntityImplCopyWithImpl(
      _$ArticleEntityImpl _value, $Res Function(_$ArticleEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? community = null,
    Object? title = null,
    Object? author = null,
    Object? content = null,
    Object? reviews = freezed,
    Object? numViews = null,
    Object? numRecommendations = null,
    Object? numReviews = null,
    Object? createdAt = null,
  }) {
    return _then(_$ArticleEntityImpl(
      community: null == community
          ? _value.community
          : community // ignore: cast_nullable_to_non_nullable
              as Community,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      reviews: freezed == reviews
          ? _value._reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as List<ArticleReviewEntity>?,
      numViews: null == numViews
          ? _value.numViews
          : numViews // ignore: cast_nullable_to_non_nullable
              as int,
      numRecommendations: null == numRecommendations
          ? _value.numRecommendations
          : numRecommendations // ignore: cast_nullable_to_non_nullable
              as int,
      numReviews: null == numReviews
          ? _value.numReviews
          : numReviews // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ArticleEntityImpl implements _ArticleEntity {
  const _$ArticleEntityImpl(
      {required this.community,
      required this.title,
      required this.author,
      required this.content,
      final List<ArticleReviewEntity>? reviews,
      required this.numViews,
      required this.numRecommendations,
      required this.numReviews,
      required this.createdAt})
      : _reviews = reviews;

  factory _$ArticleEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArticleEntityImplFromJson(json);

  @override
  final Community community;
  @override
  final String title;
  @override
  final String author;
  @override
  final String content;
  final List<ArticleReviewEntity>? _reviews;
  @override
  List<ArticleReviewEntity>? get reviews {
    final value = _reviews;
    if (value == null) return null;
    if (_reviews is EqualUnmodifiableListView) return _reviews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int numViews;
  @override
  final int numRecommendations;
  @override
  final int numReviews;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ArticleEntity(community: $community, title: $title, author: $author, content: $content, reviews: $reviews, numViews: $numViews, numRecommendations: $numRecommendations, numReviews: $numReviews, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArticleEntityImpl &&
            (identical(other.community, community) ||
                other.community == community) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._reviews, _reviews) &&
            (identical(other.numViews, numViews) ||
                other.numViews == numViews) &&
            (identical(other.numRecommendations, numRecommendations) ||
                other.numRecommendations == numRecommendations) &&
            (identical(other.numReviews, numReviews) ||
                other.numReviews == numReviews) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      community,
      title,
      author,
      content,
      const DeepCollectionEquality().hash(_reviews),
      numViews,
      numRecommendations,
      numReviews,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ArticleEntityImplCopyWith<_$ArticleEntityImpl> get copyWith =>
      __$$ArticleEntityImplCopyWithImpl<_$ArticleEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArticleEntityImplToJson(
      this,
    );
  }
}

abstract class _ArticleEntity implements ArticleEntity {
  const factory _ArticleEntity(
      {required final Community community,
      required final String title,
      required final String author,
      required final String content,
      final List<ArticleReviewEntity>? reviews,
      required final int numViews,
      required final int numRecommendations,
      required final int numReviews,
      required final DateTime createdAt}) = _$ArticleEntityImpl;

  factory _ArticleEntity.fromJson(Map<String, dynamic> json) =
      _$ArticleEntityImpl.fromJson;

  @override
  Community get community;
  @override
  String get title;
  @override
  String get author;
  @override
  String get content;
  @override
  List<ArticleReviewEntity>? get reviews;
  @override
  int get numViews;
  @override
  int get numRecommendations;
  @override
  int get numReviews;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$ArticleEntityImplCopyWith<_$ArticleEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
