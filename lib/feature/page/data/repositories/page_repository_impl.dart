import 'package:fpdart/fpdart.dart';
import 'package:notion_app/core/error/exceptions.dart';
import 'package:notion_app/core/error/failure.dart';
import 'package:notion_app/feature/page/data/datasources/page_remote_datasource.dart';
import 'package:notion_app/feature/page/domain/entities/page_entity.dart';
import 'package:notion_app/feature/page/domain/repositories/page_repository.dart';
import 'package:notion_app/feature/page/domain/usecases/usecase_params.dart';

class PageRepositoryImpl implements PageRepository {
  final PageRemoteDataSource _remote;
  const PageRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<PageEntity>>> getPages() {
    return _guard(() async {
      final models = await _remote.getPages();
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, PageEntity>> createPage(CreatePageParams params) {
    return _guard(() async {
      final model = await _remote.createPage(params.title);
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> renamePage(RenamePageParams params) {
    return _guard(() => _remote.renamePage(id: params.id, title: params.title));
  }

  @override
  Future<Either<Failure, void>> trashPage(PageIdParams params) {
    return _guard(() => _remote.trashPage(params.id));
  }

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on EmptyException {
      return Left(EmptyFailure());
    } on ServerException {
      return Left(ServerFailure());
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}
