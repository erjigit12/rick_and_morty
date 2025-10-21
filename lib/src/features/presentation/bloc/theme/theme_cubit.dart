import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'theme_state.dart';

const _themeKey = 'is_dark_mode';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({required Box<dynamic> settingsBox})
    : _settingsBox = settingsBox,
      super(const ThemeState.initial()) {
    final savedValue = _settingsBox.get(_themeKey) as bool?;
    if (savedValue != null) {
      emit(state.copyWith(isDarkMode: savedValue));
    }
  }

  final Box<dynamic> _settingsBox;

  Future<void> toggleTheme() async {
    final newValue = !state.isDarkMode;
    await _settingsBox.put(_themeKey, newValue);
    emit(state.copyWith(isDarkMode: newValue));
  }
}
