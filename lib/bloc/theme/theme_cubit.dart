import 'package:TeamLead/setting/setting_reposirory_interface.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({required SettingRepositoryInterface settingRepository})
      : _settingRepository = settingRepository,
        super(ThemeState(Brightness.light)) {
    checkSelectedTheme();
  }

  final SettingRepositoryInterface _settingRepository;

  Future<void> setThemeBrightness(Brightness brightness) async {
    emit(ThemeState(brightness));
    await _settingRepository.setThemeSelect(brightness == Brightness.dark);
  }

  void checkSelectedTheme() {
    final brightness =
        _settingRepository.isThemeSelect() ? Brightness.dark : Brightness.light;
    emit(ThemeState(brightness));
  }
}
