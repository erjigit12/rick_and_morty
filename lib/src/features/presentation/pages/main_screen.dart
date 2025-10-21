// ignore_for_file: deprecated_member_use

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rick_morty/src/features/presentation/bloc/main/main_cubit.dart';
import 'package:rick_morty/src/features/presentation/pages/favorite_screen.dart';
import 'package:rick_morty/src/features/presentation/pages/person_screen.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScreen(const [HomePage(), FavoriteScreen()]);
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen(this.items, {super.key});
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<MainCubit>().state;
    final theme = Theme.of(context);
    final bottomTheme = theme.bottomNavigationBarTheme;
    final selectedColor = bottomTheme.selectedItemColor ?? theme.colorScheme.primary;
    final unselectedColor =
        bottomTheme.unselectedItemColor ?? theme.colorScheme.onSurfaceVariant;

    return Scaffold(
      body: items[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: bottomTheme.backgroundColor ?? theme.colorScheme.background,
        selectedItemColor: selectedColor,
        unselectedItemColor: unselectedColor,
        selectedLabelStyle:
            bottomTheme.selectedLabelStyle ?? const TextStyle(height: 2),
        unselectedLabelStyle:
            bottomTheme.unselectedLabelStyle ??
            TextStyle(height: 2, color: unselectedColor),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: currentIndex,

        onTap: (index) async {
          context.read<MainCubit>().change(index);
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
              colorFilter: ColorFilter.mode(
                currentIndex == 0 ? selectedColor : unselectedColor,
                BlendMode.srcIn,
              ),
            ),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/favorites.svg',
              colorFilter: ColorFilter.mode(
                currentIndex == 1 ? selectedColor : unselectedColor,
                BlendMode.srcIn,
              ),
            ),
            label: 'Избранное',
          ),
        ],
      ),
    );
  }
}
