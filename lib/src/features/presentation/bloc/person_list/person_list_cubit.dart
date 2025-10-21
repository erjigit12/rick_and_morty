// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_morty/src/core/error/failure.dart';
import 'package:rick_morty/src/features/domain/entities/person_entity.dart';
import 'package:rick_morty/src/features/domain/usecases/get_all_persons_usecase.dart';

part 'person_list_state.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHED_FAILURE_MESSAGE = 'Cache Failure';

class PersonListCubit extends Cubit<PersonListState> {
  final GetAllPersonsUsecase getAllPersonsUsecase;
  PersonListCubit({required this.getAllPersonsUsecase}) : super(PersonListInitial());

  int page = 1;

  Future<void> loadPerson() async {
    if (state is PersonListLoading) return;

    final requestedPage = page;

    var oldPerson = <PersonEntity>[];
    if (state is PersonListSuccess && requestedPage != 1) {
      oldPerson = List<PersonEntity>.from(
        (state as PersonListSuccess).personList,
      );
    }

    emit(PersonListLoading(oldPerson, isFirstFetch: requestedPage == 1));

    final failureOrPerson = await getAllPersonsUsecase(PagePersonParams(page: page));

    failureOrPerson.fold(
      (error) {
        if (requestedPage != page) return;
        emit(PersonListError(message: mapFailureToMessage(error)));
      },
      (characters) {
        if (requestedPage != page) return;
        page = requestedPage + 1;
        final persons = List<PersonEntity>.from(
          (state as PersonListLoading).oldPersonsList,
        )..addAll(characters);
        log('List length: ${persons.length}');
        emit(PersonListSuccess(persons));
      },
    );
  }

  Future<void> refreshPersons() async {
    page = 1;
    emit(PersonListInitial());
    await loadPerson();
  }
}

String mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure():
      return SERVER_FAILURE_MESSAGE;
    case CacheFailure():
      return CACHED_FAILURE_MESSAGE;
    default:
      return 'Unexpected failure';
  }
}
