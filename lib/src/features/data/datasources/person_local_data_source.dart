// ignore_for_file: constant_identifier_names, void_checks

import 'dart:convert';
import 'dart:developer' as developer;

import 'package:hive/hive.dart';
import 'package:rick_morty/src/core/error/exception.dart';
import 'package:rick_morty/src/features/data/models/person_model.dart';

abstract class PersonLocalDataSource {
  // this is will be local database
  Future<List<PersonModel>> getLastPersonFromCache();
  Future<void> personToCache(List<PersonModel> persons);
  Future<List<PersonModel>> getFavoritePersons();
  Future<bool> toggleFavorite(PersonModel person);
  Future<bool> isFavorite(int id);
}

const CACHED_PERSONS_LIST = 'CACHED_PERSONS_LIST';
const FAVORITE_PERSONS_LIST = 'FAVORITE_PERSONS_LIST';

class PersonLocalDataSourceImpl implements PersonLocalDataSource {
  final Box<dynamic> personsBox;

  PersonLocalDataSourceImpl({required this.personsBox});

  @override
  Future<List<PersonModel>> getLastPersonFromCache() {
    final dynamic storedList = personsBox.get(CACHED_PERSONS_LIST);
    if (storedList is List) {
      return Future.value(
        storedList
            .map((person) => PersonModel.fromJson(
                  jsonDecode(person as String) as Map<String, dynamic>,
                ))
            .toList(),
      );
    }
    throw CacheException();
  }

  @override
  Future<void> personToCache(List<PersonModel> persons) async {
    final List<String> jsonPersonsList =
        persons.map((person) => jsonEncode(person.toJson())).toList();

    await personsBox.put(CACHED_PERSONS_LIST, jsonPersonsList);
    developer.log('Persons cached: ${jsonPersonsList.length}');
  }

  @override
  Future<List<PersonModel>> getFavoritePersons() {
    final dynamic storedList =
        personsBox.get(FAVORITE_PERSONS_LIST, defaultValue: <String>[]);

    if (storedList is List) {
      final favorites = storedList
          .map(
            (person) => PersonModel.fromJson(
              jsonDecode(person as String) as Map<String, dynamic>,
            ),
          )
          .toList();
      developer.log('Favorites loaded: ${favorites.length}');
      return Future.value(favorites);
    }
    return Future.value([]);
  }

  @override
  Future<bool> toggleFavorite(PersonModel person) async {
    final storedList =
        personsBox.get(FAVORITE_PERSONS_LIST, defaultValue: <String>[]);
    final favorites = List<String>.from(
      storedList is List ? storedList : <String>[],
    );

    final decodedFavorites = favorites
        .map(
          (personJson) =>
              PersonModel.fromJson(jsonDecode(personJson) as Map<String, dynamic>),
        )
        .toList();

    final existingIndex =
        decodedFavorites.indexWhere((item) => item.id == person.id);
    bool added;

    if (existingIndex >= 0) {
      decodedFavorites.removeAt(existingIndex);
      added = false;
    } else {
      decodedFavorites.add(person);
      added = true;
    }

    final updatedJson = decodedFavorites
        .map((person) => jsonEncode(person.toJson()))
        .toList(growable: false);
    await personsBox.put(FAVORITE_PERSONS_LIST, updatedJson);
    developer.log(
      'Favorite ${added ? 'added' : 'removed'}: ${person.name}',
    );
    return added;
  }

  @override
  Future<bool> isFavorite(int id) async {
    final dynamic storedList =
        personsBox.get(FAVORITE_PERSONS_LIST, defaultValue: <String>[]);
    if (storedList is! List) return false;
    for (final personJson in storedList) {
      final personMap =
          jsonDecode(personJson as String) as Map<String, dynamic>;
      if ((personMap['id'] as int) == id) {
        return true;
      }
    }
    return false;
  }
}
