import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:notion_app/core/error/failure.dart';
import 'package:notion_app/core/usecase/use_case.dart';
import 'package:notion_app/feature/page/domain/repositories/page_repository.dart';

class TrashPageUseCase implements UseCase<void, Params> {
  final PageRepository _pageRepository;
  const TrashPageUseCase(this._pageRepository);

  @override
  Future<Either<Failure, void>> call(Params params) {
    return _pageRepository.trashPage(params);
  }
}

class Params extends Equatable {
  final String id;

  const Params({required this.id});

  @override
  List<Object?> get props => [id];
}
