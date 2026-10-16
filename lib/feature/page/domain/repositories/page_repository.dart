import 'package:fpdart/fpdart.dart';
import 'package:notion_app/core/error/failure.dart';
import 'package:notion_app/feature/page/domain/entities/page_entity.dart';
import 'package:notion_app/feature/page/domain/usecases/usecase_params.dart';

abstract class PageRepository {
  Future<Either<Failure, List<PageEntity>>> getPages();
  Future<Either<Failure, PageEntity>> createPage(CreatePageParams params);
  Future<Either<Failure, void>> renamePage(RenamePageParams params);
  Future<Either<Failure, void>> trashPage(PageIdParams params);
}