import 'package:zippy/app/utils/format.dart';
import 'package:zippy/domain/model/article.model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class ArticleEntity extends Equatable {
  final int? id;
  final int source_id;
  final String title;
  final String? subtitle;
  final String? subtitle_en;
  final String link;
  final String author;
  final String content;
  final String formatted_content;
  // final String formatted_content_en;
  final List<dynamic> images;
  // final String tags;
  final String? summary;
  final String? summary_en;
  // final String chat_conversation;
  // final String embedding;
  final List<dynamic>? attachments;
  final List<String>? keyPoints;
  final List<String>? keyPoints_en;
  final List<String>? keywords;
  final List<String>? keywords_en;
  // final String topic;
  // final String terms;
  final DateTime published;

  const ArticleEntity({
    this.id,
    required this.source_id,
    required this.title,
    this.subtitle,
    this.subtitle_en,
    required this.link,
    required this.author,
    required this.content,
    required this.formatted_content,
    // required this.formatted_content_en,
    required this.images,
    // required this.tags,
    this.summary,
    this.summary_en,
    // required this.chat_conversation,
    // required this.embedding,
    this.attachments,
    this.keyPoints,
    this.keyPoints_en,
    this.keywords,
    this.keywords_en,
    // required this.topic,
    // required this.terms,
    required this.published,
  });

  @override
  List<Object> get props {
    return [
      source_id,
      title,
      link,
      author,
      content,
      // formatted_content,
      // formatted_content_en,
      images,
      // tags,
      // summary,
      // chat_conversation,
      // embedding,
      // keyPoints,
      // keywords,
      // keywords_en,
      // topic,
      // terms,
      published,
    ];
  }

  factory ArticleEntity.fromJson(Map<String, dynamic> json) {
    return ArticleEntity(
      id: json['id'],
      source_id: json['source_id'],
      title: json['title'],
      subtitle: json['subtitle'],
      subtitle_en: json['subtitle_en'],
      link: json['link'],
      author: json['author'],
      content: json['content'],
      formatted_content: json['formatted_content'],
      // formatted_content_en: json['formatted_content_en'],
      images: json['images'],
      // tags: json['tags'],
      summary: json['summary'],
      summary_en: json['summary_en'],
      // chat_conversation: json['chat_conversation'],
      // embedding: json['embedding'],
      attachments: json['attachments'],
      keyPoints: convertToStringList(json['key_points']),
      keyPoints_en: convertToStringList(json['key_points_en']),
      keywords: convertToStringList(json['keywords']),
      keywords_en: convertToStringList(json['keywords_en']),
      // topic: json['topic'],
      // terms: json['terms'],
      published: json['published'] != null
          ? DateTime.parse(json['published'])
          : DateTime.now(), // 또는 다른 기본값
    );
  }

  Article toModel() {
    return Article(
      id: id,
      sourceId: source_id,
      link: link,
      title: title,
      subtitle: subtitle,
      subtitleEn: subtitle_en,
      author: author,
      content: content,
      formattedContent: formatted_content,
      // formattedContentEn: formatted_content_en,
      images: images,
      // tags: tags,
      summary: summary,
      summaryEn: summary_en,
      // chatConversation: chat_conversation,
      // embedding: embedding,
      attachments: attachments,
      keyPoints: keyPoints,
      keyPointsEn: keyPoints_en,
      keywords: keywords,
      keywordsEn: keywords_en,
      // topic: topic,
      // terms: terms,
      published: published,
    );
  }
}
