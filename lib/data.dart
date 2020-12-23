import 'package:flutter/material.dart';

class Data {
  Data({@required this.author, @required this.title, @required this.thumbnailUrl});
  final String author;
  final String title;
  final String thumbnailUrl;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      author: json['data']['author'] ?? '',
      title: json['data']['title'] ?? '',
     thumbnailUrl: json['data']['thumbnail'] ?? '',
  );
}

