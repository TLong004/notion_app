import 'package:equatable/equatable.dart';

class PageEntity extends Equatable {
  final String id;
  final String title;
  final String? emoji;
  final DateTime lastEditedTime;

  const PageEntity({
    required this.id,
    required this.title,
    required this.emoji,
    required this.lastEditedTime,
  });

  @override
  List<Object?> get props => [id, title, emoji, lastEditedTime];
}
