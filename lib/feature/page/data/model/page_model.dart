import 'package:notion_app/feature/page/domain/entities/page_entity.dart';

class PageModel {
  const PageModel({
    required this.id,
    required this.title,
    required this.lastEditedTime,
    this.emoji,
  });

  final String id;
  final String title;
  final String? emoji;
  final DateTime lastEditedTime;

  factory PageModel.fromJson(Map<String, dynamic> json) {
    final icon = json['icon'];
    final emoji = icon is Map<String, dynamic> ? icon['emoji'] as String? : null;
    return PageModel(
      id: json['id'] as String,
      title: (json['title'] as String?) ?? '',
      emoji: emoji,
      lastEditedTime: DateTime.parse(json['last_edited_time'] as String).toLocal(),
    );
  }

  PageEntity toEntity() => PageEntity(
        id: id,
        title: title,
        emoji: emoji,
        lastEditedTime: lastEditedTime,
      );
}