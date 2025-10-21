import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty/src/features/presentation/bloc/favorites/favorites_cubit.dart';
import 'package:rick_morty/src/features/presentation/widgets/person_card_widget.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites'), centerTitle: true),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.favorites.isEmpty) {
            return const _EmptyFavorites();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sort by:',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<FavoriteSort>(
                        value: state.sort,
                        dropdownColor: theme.cardColor,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                        iconEnabledColor: colorScheme.onSurface,
                        items: const [
                          DropdownMenuItem(
                            value: FavoriteSort.name,
                            child: Text('Name'),
                          ),
                          DropdownMenuItem(
                            value: FavoriteSort.status,
                            child: Text('Status'),
                          ),
                        ],
                        onChanged: (sort) {
                          if (sort != null) {
                            context.read<FavoritesCubit>().changeSort(sort);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(
                    state.errorMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  itemBuilder: (context, index) {
                    final person = state.favorites[index];
                    return PersonCard(
                      person: person,
                      isFavorite: true,
                      onToggleFavorite: () =>
                          context.read<FavoritesCubit>().toggleFavorite(person),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      Divider(color: theme.dividerColor),
                  itemCount: state.favorites.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Favorites list is empty',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
