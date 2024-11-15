import 'package:zippy/app/utils/format.dart';
import 'package:zippy/data/entity/article_metadata.entity.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ArticleEntity extends Equatable {
  final int? id;
  final int source_id;
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

  final ArticleMetadataEntity? metadata;

  const ArticleEntity({
    this.id,
    required this.source_id,
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
  });

  @override
  List<Object> get props {
    return [
      source_id,
      title,
      link,
      author,
      content,
      images,
      published,
    ];
  }

  factory ArticleEntity.fromJson(Map<String, dynamic> json) {
    return ArticleEntity(
      id: json['id'],
      source_id: json['source_id'],
      title: json['title'],
      subtitle: json['subtitle'],
      link: json['link'],
      author: json['author'],
      content: json['content'],
      images: json['images'],
      summary: json['summary'],
      attachments: json['attachments'],
      keyPoints: convertToStringList(json['key_points']),
      keywords: convertToStringList(json['keywords']),
      published: json['published'] != null
          ? DateTime.parse(json['published'])
          : DateTime.now(), // 또는 다른 기본값
      metadata: json['article_metadata'] != null
          ? ArticleMetadataEntity.fromJson(json['article_metadata'])
          : null,
    );
  }

  Article toModel() {
    return Article(
      id: id,
      sourceId: source_id,
      link: link,
      title: title,
      subtitle: subtitle,
      author: author,
      content: content,
      images: images,
      summary: summary,
      attachments: attachments,
      keyPoints: keyPoints,
      keywords: keywords,
      published: published,
      metadata: metadata?.toModel(),
    );
  }
}
