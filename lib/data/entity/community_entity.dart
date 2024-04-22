// ignore_for_file: non_constant_identifier_names

import 'package:zippy/domain/model/community.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class CommunityEntity extends Equatable {
  final int? id;
  final String name;
  final String name_ko;
  final String base_url;
  final String list_view_url;
  final String item_view_url;

  const CommunityEntity(
      {this.id,
      required this.name,
      required this.name_ko,
      required this.base_url,
      required this.list_view_url,
      required this.item_view_url});

  @override
  List<Object> get props {
    return [name, name_ko, base_url, list_view_url, item_view_url];
  }

  factory CommunityEntity.fromJson(Map<String, dynamic> json) {
    return CommunityEntity(
      id: json['id'],
      name: json['name'],
      name_ko: json['name_ko'],
      base_url: json['base_url'],
      list_view_url: json['list_view_url'],
      item_view_url: json['item_view_url'],
    );
  }

  Community toModel() {
    return Community(
      id: id,
      name: name,
      nameKo: name_ko,
      baseUrl: base_url,
      listViewUrl: list_view_url,
      itemViewUrl: item_view_url,
    );
  }
}
