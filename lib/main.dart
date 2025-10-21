import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty/locator_service.dart' as di;
import 'package:rick_morty/locator_service.dart';
import 'package:rick_morty/src/core/theme/app_theme.dart';
import 'package:rick_morty/src/features/presentation/bloc/favorites/favorites_cubit.dart';
import 'package:rick_morty/src/features/presentation/bloc/main/main_cubit.dart';
import 'package:rick_morty/src/features/presentation/bloc/person_list/person_list_cubit.dart';
import 'package:rick_morty/src/features/presentation/bloc/search/search_bloc.dart';
import 'package:rick_morty/src/features/presentation/bloc/theme/theme_cubit.dart';
import 'package:rick_morty/src/features/presentation/pages/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainCubit>(create: (context) => sl<MainCubit>()),
        BlocProvider<PersonListCubit>(
          create: (context) => sl<PersonListCubit>()..loadPerson(),
        ),
        BlocProvider<FavoritesCubit>(
          create: (context) => sl<FavoritesCubit>()..loadFavorites(),
        ),
        BlocProvider<ThemeCubit>(create: (context) => sl<ThemeCubit>()),
        BlocProvider<PersonSearchBloc>(create: (context) => sl<PersonSearchBloc>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Rick and Morty',
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const MainView(),
          );
        },
      ),
    );
  }
}
