part of 'person_list_cubit.dart';

abstract class PersonListState extends Equatable {
  const PersonListState();

  @override
  List<Object> get props => [];
}

class PersonListInitial extends PersonListState {
  @override
  List<Object> get props => [];
}

class PersonListLoading extends PersonListState {
  final List<PersonEntity> oldPersonsList;
  final bool isFirstFetch;

  const PersonListLoading(this.oldPersonsList, {this.isFirstFetch = false});

  @override
  List<Object> get props => [oldPersonsList];
}

class PersonListSuccess extends PersonListState {
  final List<PersonEntity> personList;

  const PersonListSuccess(this.personList);

  @override
  List<Object> get props => [personList];
}

class PersonListError extends PersonListState {
  final String message;

  const PersonListError({required this.message});

  @override
  List<Object> get props => [message];
}
