import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:notion_app/core/error/failure.dart';
import 'package:notion_app/core/extensions/page_validator_extension.dart';
import 'package:notion_app/core/usecase/use_case.dart';
import 'package:notion_app/feature/page/domain/entities/page_entity.dart';
import 'package:notion_app/feature/page/domain/repositories/page_repository.dart';

class CreatePageUseCase implements UseCase<PageEntity, Params> {
  final PageRepository _pageRepository;
  const CreatePageUseCase(this._pageRepository);

  @override
  Future<Either<Failure, PageEntity>> call(Params params) async {
    final title = params.title.trim();

    if (!title.isPageTitleValid) {
      return Left(
        ValidationFailure(message: 'Page title must not be empty and must not exceed 200 characters'),
      );
    }

    return _pageRepository.createPage(params);
  }
}

class Params extends Equatable {
  final String title;
  final String? emoji;

  const Params({
    required this.title,
    this.emoji,
  });

  @override
  List<Object?> get props => [title, emoji];
}
