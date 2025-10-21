import 'package:dartz/dartz.dart';
import 'package:rick_morty/src/core/error/exception.dart';
import 'package:rick_morty/src/core/error/failure.dart';
import 'package:rick_morty/src/core/network/network_info.dart';
import 'package:rick_morty/src/features/data/datasources/person_local_data_source.dart';
import 'package:rick_morty/src/features/data/datasources/person_remote_data_source.dart';
import 'package:rick_morty/src/features/data/models/person_model.dart';
import 'package:rick_morty/src/features/domain/entities/person_entity.dart';
import 'package:rick_morty/src/features/domain/repositories/person_repository.dart';

class PersonRepositoryImpl implements PersonRepository {
  final PersonRemoteDataSource remoteDataSource;
  final PersonLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PersonRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PersonEntity>>> getAllPersons(int page) async {
    return await _getPersons(() {
      return remoteDataSource.getAllPersons(page);
    });
  }

  @override
  Future<Either<Failure, List<PersonEntity>>> searchPerson(String query) async {
    return await _getPersons(() {
      return remoteDataSource.searchPerson(query);
    });
  }

  @override
  Future<Either<Failure, List<PersonEntity>>> getFavoritePersons() async {
    try {
      final favorites = await localDataSource.getFavoritePersons();
      return Right(favorites);
    } catch (_) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(PersonEntity person) async {
    try {
      final added =
          await localDataSource.toggleFavorite(PersonModel.fromEntity(person));
      return Right(added);
    } catch (_) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(int id) async {
    try {
      final result = await localDataSource.isFavorite(id);
      return Right(result);
    } catch (_) {
      return Left(CacheFailure());
    }
  }

  Future<Either<Failure, List<PersonEntity>>> _getPersons(
    Future<List<PersonModel>> Function() getPersons,
  ) async {
    if (await networkInfo.isConnnected) {
      try {
        final remotePerson = await getPersons();
        await localDataSource.personToCache(remotePerson);
        return Right(remotePerson);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final locationPerson = await localDataSource.getLastPersonFromCache();
        return Right(locationPerson);
      } on CacheException {
        return left(CacheFailure());
      }
    }
  }
}
