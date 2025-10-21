// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rick_morty/src/core/error/failure.dart';
import 'package:rick_morty/src/core/usecases/usecase.dart';
import 'package:rick_morty/src/features/domain/entities/person_entity.dart';
import 'package:rick_morty/src/features/domain/usecases/get_favorite_persons_usecase.dart';
import 'package:rick_morty/src/features/domain/usecases/toggle_favorite_usecase.dart';

part 'favorites_state.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHED_FAILURE_MESSAGE = 'Cache Failure';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({
    required this.getFavoritePersonsUsecase,
    required this.toggleFavoriteUsecase,
  }) : super(const FavoritesState());

  final GetFavoritePersonsUsecase getFavoritePersonsUsecase;
  final ToggleFavoriteUsecase toggleFavoriteUsecase;

  Future<void> loadFavorites() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await getFavoritePersonsUsecase(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          favorites: const [],
          errorMessage: mapFailureToMessage(failure),
        ),
      ),
      (favorites) => emit(
        state.copyWith(
          isLoading: false,
          favorites: _sortFavorites(favorites, state.sort),
          clearError: true,
        ),
      ),
    );
  }

  Future<void> toggleFavorite(PersonEntity person) async {
    final result = await toggleFavoriteUsecase(ToggleFavoriteParams(person: person));
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: mapFailureToMessage(failure))),
      (added) {
        final updated = List<PersonEntity>.from(state.favorites);
        if (added) {
          updated.removeWhere((item) => item.id == person.id);
          updated.add(person);
        } else {
          updated.removeWhere((item) => item.id == person.id);
        }
        emit(
          state.copyWith(
            favorites: _sortFavorites(updated, state.sort),
            clearError: true,
          ),
        );
      },
    );
  }

  void changeSort(FavoriteSort sort) {
    if (sort == state.sort) return;
    emit(
      state.copyWith(sort: sort, favorites: _sortFavorites(state.favorites, sort)),
    );
  }

  bool isFavorite(int id) {
    return state.favorites.any((person) => person.id == id);
  }

  List<PersonEntity> _sortFavorites(
    List<PersonEntity> favorites,
    FavoriteSort sort,
  ) {
    final sorted = List<PersonEntity>.from(favorites);
    switch (sort) {
      case FavoriteSort.name:
        sorted.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case FavoriteSort.status:
        sorted.sort(
          (a, b) => a.status.toLowerCase().compareTo(b.status.toLowerCase()),
        );
        break;
    }
    return sorted;
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
