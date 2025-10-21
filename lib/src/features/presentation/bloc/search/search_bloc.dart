// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_morty/src/core/error/failure.dart';
import 'package:rick_morty/src/features/domain/entities/person_entity.dart';
import 'package:rick_morty/src/features/domain/usecases/search_person_usecase.dart';

part 'search_event.dart';
part 'search_state.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHED_FAILURE_MESSAGE = 'Cache Failure';

class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchPersonUsecase searchPersonUsecase;
  PersonSearchBloc({required this.searchPersonUsecase}) : super(SearchInitial()) {
    on<SearchPersons>(_onEvent);
  }
  FutureOr<void> _onEvent(
    SearchPersons event,
    Emitter<PersonSearchState> emit,
  ) async {
    emit(SearchLoading());
    final failureOrPerson = await searchPersonUsecase(
      SearchPersonParams(query: event.personQuery),
    );
    emit(
      failureOrPerson.fold(
        (l) => SearchError(message: mapFailureToMessage(l)),
        (r) => SearchSuccess(persons: r),
      ),
    );
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
}
