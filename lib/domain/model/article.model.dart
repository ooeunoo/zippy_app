import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:zippy/domain/model/article_metadata.model.dart';

@immutable
class Article extends Equatable {
  final int? id;
  final int sourceId;
  final String title;
  final String link;
  final String? author;
  // final String content;
  // final String? excerpt;
  final List<dynamic> images;
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
    this.author,
    // required this.content,
    required this.images,
    // this.excerpt,
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
        // "content": content,
        // "excerpt": excerpt,
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
  final Timestamp? timestamp;

  Section({
    required this.title,
    required this.content,
    this.timestamp,
  });

  static Section fromJson(Map<String, dynamic> json) {
    return Section(
      title: json['title'],
      content: json['content'],
      timestamp: json['timestamp'] != null
          ? Timestamp.fromJson(json['timestamp'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'timestamp': timestamp?.toJson(),
      };
}

// youtube 일경우만 존재
class Timestamp {
  final String end;
  final String start;

  Timestamp({
    required this.end,
    required this.start,
  });

  static Timestamp fromJson(Map<String, dynamic> json) {
    return Timestamp(
      end: json['end'],
      start: json['start'],
    );
  }

  Map<String, dynamic> toJson() => {
        'end': end,
        'start': start,
      };
}
