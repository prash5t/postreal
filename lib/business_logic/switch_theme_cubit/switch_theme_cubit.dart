import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:postreal/presentation/themes/dark_theme.dart';
import 'package:postreal/presentation/themes/light_theme.dart';
import 'package:postreal/utils/shared_prefs_helper.dart';

class SwitchThemeCubit extends Cubit<ThemeData> {
  SwitchThemeCubit() : super(darkTheme);

  /// fyi: to know which theme to apply when app is opened
  void emitAppOpeningTheme() async {
    final bool selectedThemeIsDark = await SharedPrefsHelper.isDark();
    emit(selectedThemeIsDark ? darkTheme : lightTheme);
  }

  void switchTheme() {
    final bool currentThemeIsDark = state == darkTheme;
    emit(currentThemeIsDark ? lightTheme : darkTheme);
    SharedPrefsHelper.switchTheme(currentThemeIsDark);
  }
}
