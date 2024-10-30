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
  // final String formatted_content;
  final List<dynamic> images;
  // final String tags;
  // final String summary;
  // final String chat_conversation;
  // final String embedding;
  final List<dynamic> attachments;
  // final String key_points;
  // final String keywords;
  // final String keywords_en;
  // final String topic;
  // final String terms;
  final DateTime published;

  const ArticleEntity({
    this.id,
    required this.source_id,
    required this.title,
    this.subtitle,
    required this.link,
    required this.author,
    required this.content,
    // required this.formatted_content,
    required this.images,
    // required this.tags,
    // required this.summary,
    // required this.chat_conversation,
    // required this.embedding,
    required this.attachments,
    // required this.key_points,
    // required this.keywords,
    // required this.keywords_en,
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
      images,
      // tags,
      // summary,
      // chat_conversation,
      // embedding,
      attachments,
      // key_points,
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
      link: json['link'],
      author: json['author'],
      content: json['content'],
      // formatted_content: json['formatted_content'],
      images: json['images'],
      // tags: json['tags'],
      // summary: json['summary'],
      // chat_conversation: json['chat_conversation'],
      // embedding: json['embedding'],
      attachments: json['attachments'],
      // key_points: json['key_points'],
      // keywords: json['keywords'],
      // keywords_en: json['keywords_en'],
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
      author: author,
      content: content,
      // formattedContent: formatted_content,
      images: images,
      // tags: tags,
      // summary: summary,
      // chatConversation: chat_conversation,
      // embedding: embedding,
      attachments: attachments,
      // keyPoints: key_points,
      // keywords: keywords,
      // keywordsEn: keywords_en,
      // topic: topic,
      // terms: terms,
      published: published,
    );
  }
}
