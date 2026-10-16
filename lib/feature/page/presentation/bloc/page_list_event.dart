import 'package:equatable/equatable.dart';

sealed class PageListEvent extends Equatable {
  const PageListEvent();

  @override
  List<Object?> get props => [];
}

class LoadPagesEvent extends PageListEvent {
  const LoadPagesEvent();
}

class CreatePageEvent extends PageListEvent {
  final String title;

  const CreatePageEvent({this.title = ''});

  @override
  List<Object?> get props => [title];
}

class RenamePageEvent extends PageListEvent {
  final String id;
  final String title;

  const RenamePageEvent({required this.id, required this.title});

  @override
  List<Object?> get props => [id, title];
}

class TrashPageEvent extends PageListEvent {
  final String id;

  const TrashPageEvent({required this.id});

  @override
  List<Object?> get props => [id];
}