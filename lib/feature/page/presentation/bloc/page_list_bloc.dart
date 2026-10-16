import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notion_app/core/error/failure.dart';
import 'package:notion_app/core/usecase/use_case.dart';
import 'package:notion_app/feature/page/domain/usecases/create_page_usecase.dart';
import 'package:notion_app/feature/page/domain/usecases/get_page_usecase.dart';
import 'package:notion_app/feature/page/domain/usecases/rename_page_usecase.dart';
import 'package:notion_app/feature/page/domain/usecases/trash_page_usecase.dart';
import 'package:notion_app/feature/page/domain/usecases/usecase_params.dart';
import 'package:notion_app/feature/page/presentation/bloc/page_list_event.dart';
import 'package:notion_app/feature/page/presentation/bloc/page_list_state.dart';

class PageListBloc extends Bloc<PageListEvent, PageListState> {
  final PageGetPagesUseCase _getPagesUseCase;
  final CreatePageUseCase _createPageUseCase;
  final RenamePageUseCase _renamePageUseCase;
  final TrashPageUseCase _trashPageUseCase;

  PageListBloc({
    required PageGetPagesUseCase getPagesUseCase,
    required CreatePageUseCase createPageUseCase,
    required RenamePageUseCase renamePageUseCase,
    required TrashPageUseCase trashPageUseCase,
  })  : _getPagesUseCase = getPagesUseCase,
        _createPageUseCase = createPageUseCase,
        _renamePageUseCase = renamePageUseCase,
        _trashPageUseCase = trashPageUseCase,
        super(const PageListInitial()) {
    on<LoadPagesEvent>(_onLoadPagesEvent);
    on<CreatePageEvent>(_onCreatePageEvent);
    on<RenamePageEvent>(_onRenamePageEvent);
    on<TrashPageEvent>(_onTrashPageEvent);
  }

  Future<void> _onLoadPagesEvent(
    LoadPagesEvent event,
    Emitter<PageListState> emit,
  ) async {
    emit(const PageListLoading());
    final result = await _getPagesUseCase(NoParams());
    result.fold(
      (failure) => emit(PageListFailure(_getFailureMessage(failure))),
      (pages) => emit(PageListLoaded(pages)),
    );
  }

  Future<void> _onCreatePageEvent(
    CreatePageEvent event,
    Emitter<PageListState> emit,
  ) async {
    emit(const PageListLoading());
    final result = await _createPageUseCase(
      CreatePageParams(
        title: event.title,
      ),
    );
    result.fold(
      (failure) => emit(PageListFailure(_getFailureMessage(failure))),
      (page) => emit(PageCreated(page)),
    );
  }

  Future<void> _onRenamePageEvent(
    RenamePageEvent event,
    Emitter<PageListState> emit,
  ) async {
    emit(const PageListLoading());
    final result = await _renamePageUseCase(
      RenamePageParams(
        id: event.id,
        title: event.title,
      ),
    );
    result.fold(
      (failure) => emit(PageListFailure(_getFailureMessage(failure))),
      (_) => emit(const PageRenamed()),
    );
  }

  Future<void> _onTrashPageEvent(
    TrashPageEvent event,
    Emitter<PageListState> emit,
  ) async {
    emit(const PageListLoading());
    final result = await _trashPageUseCase(
      PageIdParams(id: event.id),
    );
    result.fold(
      (failure) => emit(PageListFailure(_getFailureMessage(failure))),
      (_) => emit(const PageTrashed()),
    );
  }

  String _getFailureMessage(Failure failure) {
    return switch (failure) {
      ValidationFailure() => failure.message,
      ServerFailure() => 'Server error. Please try again',
      CacheFailure() => 'Cache error. Please try again',
      EmptyFailure() => 'No data available',
      (_) => 'An unexpected error occurred',
    };
  }
}
