// ignore_for_file: non_constant_identifier_names

import 'package:zippy/domain/model/channel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ChannelEntity extends Equatable {
  final int? id;
  final ChannelType type;
  final String name;
  final String name_ko;
  final String base_url;
  final String list_view_url;
  final String item_view_url;

  const ChannelEntity(
      {this.id,
      required this.type,
      required this.name,
      required this.name_ko,
      required this.base_url,
      required this.list_view_url,
      required this.item_view_url});

  @override
  List<Object> get props {
    return [type, name, name_ko, base_url, list_view_url, item_view_url];
  }

  factory ChannelEntity.fromJson(Map<String, dynamic> json) {
    return ChannelEntity(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      name_ko: json['name_ko'],
      base_url: json['base_url'],
      list_view_url: json['list_view_url'],
      item_view_url: json['item_view_url'],
    );
  }

  Channel toModel() {
    return Channel(
      id: id,
      type: type,
      name: name,
      nameKo: name_ko,
      baseUrl: base_url,
      listViewUrl: list_view_url,
      itemViewUrl: item_view_url,
    );
  }
}
