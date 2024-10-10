import 'package:assistant/theme/green_theme.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_bloc_event.dart';
part 'theme_bloc_state.dart';

// enum ThemeEven { dark_event, light_event }

class ThemeBlocBloc extends Bloc<ThemeBlocEvent, ThemeBlocState> {
  ThemeData theme = greenTheme;

  ThemeBlocBloc() : super(ThemeBlocInitialState()) {
    on<ThemeInitEvent>((event, emit) {
      emit(ThemeAddState(theme: theme));
    });

    on<ThemeAddEvent>((event, emit) {
      debugPrint('${event.theme}');

      emit(ThemeAddState(theme: event.theme));
    });
  }
}
