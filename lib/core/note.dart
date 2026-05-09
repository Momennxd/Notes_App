import 'package:flutter/material.dart';

class Note {
  final int id;
  final String title;
  final String content;
  final DateTime date;
  final IconData? icon;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.icon,
  });

  Note copyWith({String? title, String? content, IconData? icon}) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: DateTime.now(),
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'content': content,
    'date': date.toIso8601String(),           
    'icon': icon?.codePoint ?? 0,             
  };

  factory Note.fromMap(Map<String, dynamic> map) => Note(
    id: map['id'],
    title: map['title'],
    content: map['content'],                  
    date: DateTime.parse(map['date']),        
    icon: map['icon'] != null && map['icon'] != 0
        ? IconData(map['icon'], fontFamily: 'MaterialIcons')  
        : null,
  );
}