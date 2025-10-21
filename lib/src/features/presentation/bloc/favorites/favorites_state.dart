part of 'favorites_cubit.dart';

enum FavoriteSort { name, status }

class FavoritesState extends Equatable {
  final List<PersonEntity> favorites;
  final bool isLoading;
  final String? errorMessage;
  final FavoriteSort sort;

  const FavoritesState({
    this.favorites = const [],
    this.isLoading = false,
    this.errorMessage,
    this.sort = FavoriteSort.name,
  });

  FavoritesState copyWith({
    List<PersonEntity>? favorites,
    bool? isLoading,
    String? errorMessage,
    FavoriteSort? sort,
    bool clearError = false,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearError ? null : (errorMessage ?? this.errorMessage),
      sort: sort ?? this.sort,
    );
  }

  @override
  List<Object?> get props => [favorites, isLoading, errorMessage, sort];
}
