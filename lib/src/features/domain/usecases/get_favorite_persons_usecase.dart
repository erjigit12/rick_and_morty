import 'package:dartz/dartz.dart';
import 'package:rick_morty/src/core/error/failure.dart';
import 'package:rick_morty/src/core/usecases/usecase.dart';
import 'package:rick_morty/src/features/domain/entities/person_entity.dart';
import 'package:rick_morty/src/features/domain/repositories/person_repository.dart';

class GetFavoritePersonsUsecase
    extends UseCase<List<PersonEntity>, NoParams> {
  final PersonRepository personRepository;

  GetFavoritePersonsUsecase({required this.personRepository});

  @override
  Future<Either<Failure, List<PersonEntity>>> call(NoParams params) async {
    return await personRepository.getFavoritePersons();
  }
}
