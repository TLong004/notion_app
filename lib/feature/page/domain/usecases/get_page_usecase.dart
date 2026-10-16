import 'package:fpdart/fpdart.dart';
import 'package:notion_app/core/error/failure.dart';
import 'package:notion_app/core/usecase/use_case.dart';
import 'package:notion_app/feature/page/domain/entities/page_entity.dart';
import 'package:notion_app/feature/page/domain/repositories/page_repository.dart';

class PageGetPagesUseCase implements UseCase<List<PageEntity>, NoParams> {
  final PageRepository _pageRepository;
  const PageGetPagesUseCase(this._pageRepository);

  @override
  Future<Either<Failure, List<PageEntity>>> call(NoParams params) {
    return _pageRepository.getPages();
  }
}