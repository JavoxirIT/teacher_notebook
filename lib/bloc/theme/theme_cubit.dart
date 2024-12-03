import 'package:TeamLead/setting/setting_reposirory_interface.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({required this.settingRepository})
      : super(ThemeState(settingRepository.isThemeSelect()
            ? Brightness.dark
            : Brightness.light));

  final SettingReposiroryInterface settingRepository;

  Future<void> setThemeBrightness(Brightness brightness) async {
    emit(ThemeState(brightness));
    await settingRepository.setThemeSelect(brightness == Brightness.dark);
  }
}
