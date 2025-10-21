part of 'search_bloc.dart';

abstract class PersonSearchState extends Equatable {
  const PersonSearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitial extends PersonSearchState {}

final class SearchLoading extends PersonSearchState {}

final class SearchSuccess extends PersonSearchState {
  final List<PersonEntity> persons;

  const SearchSuccess({required this.persons});

  @override
  List<Object> get props => [persons];
}

final class SearchError extends PersonSearchState {
  final String message;

  const SearchError({required this.message});

  @override
  List<Object> get props => [message];
}
