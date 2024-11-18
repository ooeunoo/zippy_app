import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/model/article_metadata.model.dart';

@immutable
class Article extends Equatable {
  final int? id;
  final int sourceId;
  final String title;
  final String link;
  final String author;
  final List<dynamic> images;
  final String summary;
  final List<Section> sections;
  final List<String> keyPoints;
  final List<String> keywords;
  final DateTime published;

  final ArticleMetadata? metadata;

  //
  final bool isAd;

  const Article({
    this.id,
    required this.sourceId,
    required this.title,
    required this.link,
    required this.author,
    required this.images,
    required this.summary,
    required this.sections,
    required this.keyPoints,
    required this.keywords,
    required this.published,
    this.metadata,
    this.isAd = false,
  });

  @override
  List<Object> get props {
    return [
      sourceId,
      link,
      title,
      author,
      isAd,
    ];
  }

  dynamic toJson() => {
        'id': id,
        'sourceId': sourceId,
        'link': link,
        'title': title,
        "author": author,
        "images": images,
        "summary": summary,
        "sections": sections,
        "keyPoints": keyPoints,
        "keywords": keywords,
        "published": published,
        'isAd': isAd,
        'metadata': metadata?.toJson(),
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

class Section {
  final String title;
  final List<String> content;

  Section({
    required this.title,
    required this.content,
  });

  static Section fromJson(Map<String, dynamic> json) {
    return Section(
      title: json['title'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
      };
}
