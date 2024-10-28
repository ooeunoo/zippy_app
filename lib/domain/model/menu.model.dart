import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class MenuSection extends Equatable {
  final String section;
  final List<MenuItem> items;

  const MenuSection({
    required this.section,
    required this.items,
  });

  @override
  List<Object> get props {
    return [section, items];
  }

  dynamic toJson() => {
        'section': section,
        'items': items,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

@immutable
class MenuItem extends Equatable {
  final String icon;
  final String title;
  final Function onTap;

  const MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  List<Object> get props {
    return [icon, title, onTap];
  }

  dynamic toJson() => {
        'icon': icon,
        'title': title,
        'onTap': onTap,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
