import 'package:equatable/equatable.dart';
import 'package:notion_app/feature/page/domain/entities/page_entity.dart';

sealed class PageListState extends Equatable {
  const PageListState();

  @override
  List<Object?> get props => [];
}

class PageListInitial extends PageListState {
  const PageListInitial();
}

class PageListLoading extends PageListState {
  const PageListLoading();
}

class PageListLoaded extends PageListState {
  final List<PageEntity> pages;

  const PageListLoaded(this.pages);

  @override
  List<Object?> get props => [pages];
}

class PageListFailure extends PageListState {
  final String message;

  const PageListFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class PageCreated extends PageListState {
  final PageEntity page;

  const PageCreated(this.page);

  @override
  List<Object?> get props => [page];
}

class PageRenamed extends PageListState {
  const PageRenamed();
}

class PageTrashed extends PageListState {
  const PageTrashed();
}