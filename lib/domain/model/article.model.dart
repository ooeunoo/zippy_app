import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Article extends Equatable {
  final int? id;
  final int sourceId;
  final String title;
  final String? subtitle;
  final String? subtitleEn;
  final String link;
  final String author;
  final String content;
  final String formattedContent;
  final List<dynamic> images;
  // final String tags;
  final String? summary;
  final String? summaryEn;
  // final String chatConversation;
  // final String embedding;
  final List<dynamic>? attachments;
  final List<String>? keyPoints;
  final List<String>? keyPointsEn;
  final List<String>? keywords;
  final List<String>? keywordsEn;
  // final String topic;
  // final String terms;
  final DateTime published;

  //
  final bool isAd;

  const Article({
    this.id,
    required this.sourceId,
    required this.title,
    this.subtitle,
    this.subtitleEn,
    required this.link,
    required this.author,
    required this.content,
    required this.formattedContent,
    required this.images,
    // required this.tags,
    this.summary,
    this.summaryEn,
    // required this.chatConversation,
    // required this.embedding,
    this.attachments,
    this.keyPoints,
    this.keyPointsEn,
    this.keywords,
    this.keywordsEn,
    // required this.topic,
    // required this.terms,
    required this.published,
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
        "subtitleEn": subtitleEn,
        "author": author,
        "content": content,
        "formattedContent": formattedContent,
        "images": images,
        // "tags": tags,
        "summary": summary,
        "summaryEn": summaryEn,
        // "chatConversation": chatConversation,
        // "embedding": embedding,
        "attachments": attachments,
        "keyPoints": keyPoints,
        "keyPointsEn": keyPointsEn,
        "keywords": keywords,
        "keywordsEn": keywordsEn,
        // "topic": topic,
        // "terms": terms,
        "published": published,
        'isAd': isAd
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
