part of 'student_in_a_group_bloc.dart';

sealed class StudentInAGroupBlockState extends Equatable {
  const StudentInAGroupBlockState();

  @override
  List<Object> get props => [];
}

final class StudentInAGroupBlockInitial extends StudentInAGroupBlockState {}

// КОГДА НЕТ ДАННЫХ О ГРУППЕ
final class StudentInAGroupNotDataState extends StudentInAGroupBlockState {}

// ПРИ УСПЕШНОМ ПОЛУЧЕНИЕ ДАННЫХ
final class StudentInAGroupLoadState extends StudentInAGroupBlockState {
  const StudentInAGroupLoadState(this.data);
  final List<StudentInAGroupModels> data;

  @override
  List<Object> get props => super.props..addAll([data]);
}

// ОШИБКА ПРИ ПОЛУЧЕНИЕ ДАННЫХ
final class StudentInAGroupErrorState extends StudentInAGroupBlockInitial {
  StudentInAGroupErrorState({
    required this.exception,
  });
  final Exception exception;

  @override
  List<Object> get props => super.props..add(exception);
}
