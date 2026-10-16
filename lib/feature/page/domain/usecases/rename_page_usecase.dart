import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:notion_app/core/error/failure.dart';
import 'package:notion_app/core/extensions/page_validator_extension.dart';
import 'package:notion_app/core/usecase/use_case.dart';
import 'package:notion_app/feature/page/domain/repositories/page_repository.dart';

class RenamePageUseCase implements UseCase<void, Params> {
  final PageRepository _pageRepository;
  const RenamePageUseCase(this._pageRepository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    final title = params.title.trim();

    if (!title.isPageTitleValid) {
      return Left(
        ValidationFailure(message: 'Page title must not be empty and must not exceed 200 characters'),
      );
    }

    return _pageRepository.renamePage(params);
  }
}

class Params extends Equatable {
  final String id;
  final String title;

  const Params({
    required this.id,
    required this.title,
  });

  @override
  List<Object?> get props => [id, title];
}