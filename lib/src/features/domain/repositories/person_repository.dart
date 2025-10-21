import 'package:dartz/dartz.dart';
import 'package:rick_morty/src/core/error/failure.dart';
import 'package:rick_morty/src/features/domain/entities/person_entity.dart';

abstract class PersonRepository {
  Future<Either<Failure, List<PersonEntity>>> getAllPersons(int page);
  Future<Either<Failure, List<PersonEntity>>> searchPerson(String query);
  Future<Either<Failure, List<PersonEntity>>> getFavoritePersons();
  Future<Either<Failure, bool>> toggleFavorite(PersonEntity person);
  Future<Either<Failure, bool>> isFavorite(int id);
}
