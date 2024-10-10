part of 'theme_bloc_bloc.dart';

sealed class ThemeBlocState extends Equatable {
  const ThemeBlocState();

  @override
  List<Object> get props => [];
}

final class ThemeBlocInitialState extends ThemeBlocState {}




// получение темы
final class ThemeAddState extends ThemeBlocState {
  const ThemeAddState({
    required this.theme,
  });
  final ThemeData theme;

  @override
  List<Object> get props => super.props..add(theme);
}
