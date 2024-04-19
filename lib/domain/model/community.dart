import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Community extends Equatable {
  final int? id;
  final String name;
  final String nameKo;
  final String baseUrl;
  final String listViewUrl;
  final String itemViewUrl;

  const Community(
      {this.id,
      required this.name,
      required this.nameKo,
      required this.baseUrl,
      required this.listViewUrl,
      required this.itemViewUrl});

  @override
  List<Object> get props {
    return [name, nameKo, baseUrl, listViewUrl, itemViewUrl];
  }

  dynamic toJson() => {
        'id': id,
        'name': name,
        'nameKo': nameKo,
        'baseUrl': baseUrl,
        "listViewUrl": listViewUrl,
        "itemViewUrl": itemViewUrl,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
