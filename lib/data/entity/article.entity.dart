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
  final String link;
  final String author;
  final List<dynamic> images;
  final String summary;
  final List<SectionEntity> sections;
  final List<String> keyPoints;
  final List<String> keywords;
  final DateTime published;

  final ArticleMetadataEntity? metadata;

  const ArticleEntity({
    this.id,
    required this.source_id,
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
  });

  @override
  List<Object> get props {
    return [
      source_id,
      title,
      link,
      author,
      images,
      published,
    ];
  }

  factory ArticleEntity.fromJson(Map<String, dynamic> json) {
    return ArticleEntity(
      id: json['id'],
      source_id: json['source_id'],
      title: json['title'],
      link: json['link'],
      author: json['author'],
      images: json['images'],
      summary: json['summary'],
      keyPoints: convertToStringList(json['key_points']),
      keywords: convertToStringList(json['keywords']),
      sections: List<SectionEntity>.from((json['sections'] as List)
          .map((section) => SectionEntity.fromJson(section))),
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
      author: author,
      images: images,
      summary: summary,
      sections: List<Section>.from(
          sections.map((SectionEntity section) => section.toModel())),
      keyPoints: keyPoints,
      keywords: keywords,
      published: published,
      metadata: metadata?.toModel(),
    );
  }
}

class SectionEntity {
  final String title;
  final List<String> content;

  SectionEntity({
    required this.title,
    required this.content,
  });

  factory SectionEntity.fromJson(Map<String, dynamic> json) {
    return SectionEntity(
      title: json['title'],
      content: List<String>.from(json['content']),
    );
  }

  Section toModel() {
    return Section(
      title: title,
      content: content,
    );
  }
}
