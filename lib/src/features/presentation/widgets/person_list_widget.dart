import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty/src/features/domain/entities/person_entity.dart';
import 'package:rick_morty/src/features/presentation/bloc/favorites/favorites_cubit.dart';
import 'package:rick_morty/src/features/presentation/bloc/person_list/person_list_cubit.dart';
import 'package:rick_morty/src/features/presentation/widgets/person_card_widget.dart';

class PersonList extends StatefulWidget {
  const PersonList({super.key});

  @override
  State<PersonList> createState() => _PersonListState();
}

class _PersonListState extends State<PersonList> {
  final _scrollController = ScrollController();
  static const _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      context.read<PersonListCubit>().loadPerson();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonListCubit, PersonListState>(
      builder: (context, state) {
        if (state is PersonListLoading && state.isFirstFetch) {
          return _loadingIndicator();
        }

        if (state is PersonListInitial) {
          return _loadingIndicator();
        }

        if (state is PersonListError) {
          return RefreshIndicator(
            onRefresh: () => context.read<PersonListCubit>().refreshPersons(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Center(
                    child: Text(
                      state.message,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        List<PersonEntity> persons = const [];
        bool isLoadingMore = false;

        if (state is PersonListSuccess) {
          persons = state.personList;
        } else if (state is PersonListLoading) {
          persons = state.oldPersonsList;
          isLoadingMore = true;
        } else {
          return Center(
            child: Text(
              'Error',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          );
        }

        final favoriteIds = context
            .watch<FavoritesCubit>()
            .state
            .favorites
            .map((person) => person.id)
            .toSet();

        return RefreshIndicator(
          onRefresh: () => context.read<PersonListCubit>().refreshPersons(),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index >= persons.length) {
                return _bottomLoader();
              }
              final person = persons[index];
              return PersonCard(
                person: person,
                isFavorite: favoriteIds.contains(person.id),
                onToggleFavorite: () =>
                    context.read<FavoritesCubit>().toggleFavorite(person),
              );
            },
            separatorBuilder: (context, index) {
              if (index >= persons.length - 1) {
                return const SizedBox.shrink();
              }
              return Divider(color: Theme.of(context).dividerColor);
            },
            itemCount: persons.length + (isLoadingMore ? 1 : 0),
          ),
        );
      },
    );
  }
}

Widget _loadingIndicator() {
  return const Padding(
    padding: EdgeInsets.all(8.0),
    child: Center(child: CircularProgressIndicator()),
  );
}

Widget _bottomLoader() {
  return const Padding(
    padding: EdgeInsets.symmetric(vertical: 16),
    child: Center(child: CircularProgressIndicator()),
  );
}
