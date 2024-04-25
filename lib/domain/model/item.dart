import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class Item extends Equatable {
  final bool isAd;

  const Item({this.isAd = false});

  @override
  List<Object> get props {
    return [isAd];
  }

  dynamic toJson() => {'isAd': isAd};

  @override
  String toString() {
    return toJson().toString();
  }
}
