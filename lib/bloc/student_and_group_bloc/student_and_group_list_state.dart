part of 'student_and_group_list_bloc.dart';

sealed class StudentAndGroupListState extends Equatable {
  const StudentAndGroupListState();

  @override
  List<Object> get props => [];
}

final class StudentAndGroupListInitial extends StudentAndGroupListState {}

// для получения всехстудентов и группу
final class StudentAndGroupLoadState extends StudentAndGroupListState {
  const StudentAndGroupLoadState(this.data);
  final List<StudentAndGroupModels> data;

  @override
  List<Object> get props => super.props..addAll([data]);
}

// ошибка при получение данных
final class StudentAndGroupErrorState extends StudentAndGroupListState {
  const StudentAndGroupErrorState({
    required this.exception,
  });
  final Exception exception;

  @override
  List<Object> get props => super.props..add(exception);
}

final class StudentAndGroupNoDataState extends StudentAndGroupListState {} 

