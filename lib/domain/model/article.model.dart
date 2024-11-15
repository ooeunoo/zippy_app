import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/model/article_metadata.model.dart';

@immutable
class Article extends Equatable {
  final int? id;
  final int sourceId;
  final String title;
  final String? subtitle;
  final String link;
  final String author;
  final String content;
  final List<dynamic> images;
  final String? summary;
  final List<dynamic>? attachments;
  final List<String>? keyPoints;
  final List<String>? keywords;
  final DateTime published;

  final ArticleMetadata? metadata;

  //
  final bool isAd;

  const Article({
    this.id,
    required this.sourceId,
    required this.title,
    this.subtitle,
    required this.link,
    required this.author,
    required this.content,
    required this.images,
    this.summary,
    this.attachments,
    this.keyPoints,
    this.keywords,
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
        "subtitle": subtitle,
        "author": author,
        "content": content,
        "images": images,
        "summary": summary,
        "attachments": attachments,
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
