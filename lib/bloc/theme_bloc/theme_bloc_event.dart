part of 'theme_bloc_bloc.dart';

sealed class ThemeBlocEvent extends Equatable {
  const ThemeBlocEvent();

  @override
  List<Object> get props => [];
}

final class ThemeInitEvent extends ThemeBlocEvent{}

final class ThemeAddEvent extends ThemeBlocEvent {
  const ThemeAddEvent({required this.theme});

  final ThemeData theme;

  @override
  List<Object> get props => super.props..addAll([theme]);
}
