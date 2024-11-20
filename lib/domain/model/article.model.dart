import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/enum/interaction_type.enum.dart';
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
  final List<Attachment>? attachments;

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
    this.attachments,
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
        "sections": sections?.map((section) => section.toJson()),
        "keyPoints": keyPoints,
        "keywords": keywords,
        "published": published,
        'attachments': attachments?.map((attachment) => attachment.toJson()),
        'isAd': isAd,
        'metadata': metadata?.toJson(),
      };

  @override
  String toString() {
    return toJson().toString();
  }
}

class Attachment {
  final int id;
  final String title;
  final int width;
  final int height;
  final int postId;
  final String duration;
  final String contentUrl;
  final String contentType;

  Attachment({
    required this.id,
    required this.title,
    required this.width,
    required this.height,
    required this.postId,
    required this.duration,
    required this.contentUrl,
    required this.contentType,
  });

  static Attachment fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'],
      title: json['title'],
      width: json['width'],
      height: json['height'],
      postId: json['post_id'],
      duration: json['duration'],
      contentUrl: json['content_url'],
      contentType: json['content_type'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'width': width,
        'height': height,
        'postId': postId,
        'duration': duration,
        'contentUrl': contentUrl,
        'contentType': contentType,
      };
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
