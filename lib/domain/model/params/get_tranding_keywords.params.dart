import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/model/content_type.model.dart';

@immutable
class GetTrandingKeywordsParams extends Equatable {
  final int limit;
  final String timeWindow;
  final ContentType? contentType;

  const GetTrandingKeywordsParams({
    this.limit = 10,
    this.timeWindow = '24 hour',
    this.contentType,
  });

  @override
  List<Object> get props {
    return [limit, timeWindow];
  }

  Map<String, dynamic> toJson() => {
        'p_limit': limit,
        'p_time_window': timeWindow,
        'p_content_type_id': contentType?.id,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
