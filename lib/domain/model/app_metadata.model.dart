import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/data/entity/app_metadata.entity.dart';

@immutable
class AppMetadata extends Equatable {
  final bool lookaround;

  const AppMetadata({
    required this.lookaround,
  });

  @override
  List<Object> get props {
    return [lookaround];
  }

  dynamic toJson() => {
        'lookaround': lookaround,
      };

  AppMetadataEntity toCreateEntity() =>
      AppMetadataEntity(lookaround: lookaround);

  @override
  String toString() {
    return toJson().toString();
  }
}
