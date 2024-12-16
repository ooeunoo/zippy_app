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
  final String content;
  final String? excerpt;
  final List<AttachmentEntity>? attachments;
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
    required this.content,
    this.excerpt,
    required this.keyPoints,
    required this.keywords,
    required this.published,
    this.attachments,
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
      content: json['content'],
      excerpt: json['excerpt'],
      keyPoints: convertToStringList(json['key_points']),
      keywords: convertToStringList(json['keywords']),
      published: json['published'] != null
          ? DateTime.parse(json['published'])
          : DateTime.now(), // 또는 다른 기본값
      attachments: json['attachments'] != null
          ? List<AttachmentEntity>.from(json['attachments']
              .map((attachment) => AttachmentEntity.fromJson(attachment)))
          : null,
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
      excerpt: excerpt,
      content: content,
      summary: summary,
      keyPoints: keyPoints,
      keywords: keywords,
      published: published,
      metadata: metadata?.toModel(),
      attachments: attachments != null
          ? List<Attachment>.from(attachments!
              .map((AttachmentEntity attachment) => attachment.toModel()))
          : [],
    );
  }
}

class AttachmentEntity {
  final int id;
  final String title;
  final int width;
  final int height;
  final int post_id;
  final String duration;
  final String cotent_url;
  final String content_type;

  AttachmentEntity({
    required this.id,
    required this.title,
    required this.width,
    required this.height,
    required this.post_id,
    required this.duration,
    required this.cotent_url,
    required this.content_type,
  });

  factory AttachmentEntity.fromJson(Map<String, dynamic> json) {
    return AttachmentEntity(
      id: json['id'],
      title: json['title'],
      width: json['width'],
      height: json['height'],
      post_id: json['post_id'],
      duration: json['duration'],
      cotent_url: json['content_url'],
      content_type: json['content_type'],
    );
  }

  Attachment toModel() {
    return Attachment(
      id: id,
      title: title,
      width: width,
      height: height,
      postId: post_id,
      duration: duration,
      contentUrl: cotent_url,
      contentType: content_type,
    );
  }
}

class SectionEntity {
  final String title;
  final List<String> content;
  final TimestampEntity? timestamp;

  SectionEntity({
    required this.title,
    required this.content,
    this.timestamp,
  });

  factory SectionEntity.fromJson(Map<String, dynamic> json) {
    return SectionEntity(
      title: json['title'],
      content: List<String>.from(json['content']),
      timestamp: json['timestamp'] != null
          ? TimestampEntity.fromJson(json['timestamp'])
          : null,
    );
  }

  Section toModel() {
    return Section(
      title: title,
      content: content,
      timestamp: timestamp?.toModel(),
    );
  }
}

class TimestampEntity {
  final String end;
  final String start;

  TimestampEntity({
    required this.end,
    required this.start,
  });

  factory TimestampEntity.fromJson(Map<String, dynamic> json) {
    return TimestampEntity(
      end: json['end'],
      start: json['start'],
    );
  }

  Timestamp toModel() {
    return Timestamp(
      end: end,
      start: start,
    );
  }
}
