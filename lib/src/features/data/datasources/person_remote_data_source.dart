import 'package:dio/dio.dart';
import 'package:rick_morty/src/core/error/exception.dart';
import 'package:rick_morty/src/core/network/api.dart';
import 'package:rick_morty/src/features/data/models/person_model.dart';

abstract class PersonRemoteDataSource {
  Future<List<PersonModel>> getAllPersons(int page);
  Future<List<PersonModel>> searchPerson(String query);
}

class PersonRemoteDataSourceImpl implements PersonRemoteDataSource {
  final Dio dio;

  PersonRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PersonModel>> getAllPersons(int page) =>
      _getPersonFromUrl('${AppApi.baseUrl}?page=$page');

  @override
  Future<List<PersonModel>> searchPerson(String query) =>
      _getPersonFromUrl('${AppApi.baseUrl}?name=$query');

  Future<List<PersonModel>> _getPersonFromUrl(String url) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        url,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final persons = response.data!;
        return (persons['results'] as List<dynamic>)
            .map((person) => PersonModel.fromJson(person as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException();
      }
    } on DioException {
      throw ServerException();
    }
  }
}
