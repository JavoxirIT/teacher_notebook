part of 'student_bloc.dart';

sealed class StudentState extends Equatable {
  const StudentState();

  @override
  List<Object> get props => [];
}

// если нету данных
final class StudentInitialState extends StudentState {}

// при загрузкой данных
class StudentLoadingState extends StudentState {}

// после получения данных
final class StudentLoadedState extends StudentState {
  const StudentLoadedState({
    required this.loadedStudent,
  });
  final List<StudentDB> loadedStudent;

  @override
  List<Object> get props => super.props..add(loadedStudent);
}

// ошибка при получение данных
final class StudentErrorState extends StudentState {
  const StudentErrorState({
    required this.exception,
  });
  final Exception exception;

  @override
  List<Object> get props => super.props..add(exception);
}

// ошибка при получение данных
class StudentNoDataState extends StudentState {}

// ошибка при получение данных
class StudentSearchState extends StudentState {}

// при запуске поиска
class StudentSearchLoadinState extends StudentState{}

// при запуске поиска
class StudentSearchNoDataState extends StudentState{}