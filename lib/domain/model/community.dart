import 'package:cocomu/app/utils/assets.dart';
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
  final String? logo; // after assign by toIdAssign()

  const Community(
      {this.id,
      required this.name,
      required this.nameKo,
      required this.baseUrl,
      required this.listViewUrl,
      required this.itemViewUrl,
      this.logo});

  @override
  List<Object> get props {
    return [name, nameKo, baseUrl, listViewUrl, itemViewUrl];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'nameKo': nameKo,
        'baseUrl': baseUrl,
        "listViewUrl": listViewUrl,
        "itemViewUrl": itemViewUrl,
      };

  Map<int, Community> toIdAssign(Map<int, Community> map) {
    if (id != null) {
      map[id!] = Community(
        name: name,
        nameKo: nameKo,
        baseUrl: baseUrl,
        listViewUrl: listViewUrl,
        itemViewUrl: itemViewUrl,
        logo: getLogoAssetPath(),
      );
    }
    return map;
  }

  String? getLogoAssetPath() {
    switch (id) {
      // case 2: // 디시
      //   break;
      // case 3: // 뽐뿌
      //   break;
      // case 4: // 인스티즈
      //   break;
      case 5: // 웃긴대학
        return Assets.humorunivLogo;
    }
    return null;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
