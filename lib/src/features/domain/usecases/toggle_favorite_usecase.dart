import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_morty/src/core/error/failure.dart';
import 'package:rick_morty/src/core/usecases/usecase.dart';
import 'package:rick_morty/src/features/domain/entities/person_entity.dart';
import 'package:rick_morty/src/features/domain/repositories/person_repository.dart';

class ToggleFavoriteUsecase extends UseCase<bool, ToggleFavoriteParams> {
  final PersonRepository personRepository;

  ToggleFavoriteUsecase({required this.personRepository});

  @override
  Future<Either<Failure, bool>> call(ToggleFavoriteParams params) async {
    return await personRepository.toggleFavorite(params.person);
  }
}

class ToggleFavoriteParams extends Equatable {
  final PersonEntity person;

  const ToggleFavoriteParams({required this.person});

  @override
  List<Object?> get props => [person];
}
