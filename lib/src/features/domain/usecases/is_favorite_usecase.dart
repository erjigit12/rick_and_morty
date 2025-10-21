import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_morty/src/core/error/failure.dart';
import 'package:rick_morty/src/core/usecases/usecase.dart';
import 'package:rick_morty/src/features/domain/repositories/person_repository.dart';

class IsFavoriteUsecase extends UseCase<bool, IsFavoriteParams> {
  final PersonRepository personRepository;

  IsFavoriteUsecase({required this.personRepository});

  @override
  Future<Either<Failure, bool>> call(IsFavoriteParams params) async {
    return await personRepository.isFavorite(params.id);
  }
}

class IsFavoriteParams extends Equatable {
  final int id;

  const IsFavoriteParams({required this.id});

  @override
  List<Object?> get props => [id];
}
