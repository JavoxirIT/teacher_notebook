part of 'student_and_group_list_bloc.dart';

sealed class StudentAndGroupListEvent extends Equatable {
  const StudentAndGroupListEvent();

  @override
  List<Object> get props => [];
}

class StudentAndGroupLoadEvent extends StudentAndGroupListEvent {
  const StudentAndGroupLoadEvent(this.id);

  final int? id;

  @override
  List<Object> get props => super.props..addAll([id!]);
}


class StudentAndGroupSelectionEvent extends StudentAndGroupListEvent {
  const StudentAndGroupSelectionEvent(
      {required this.studentId, required this.isSelected});

  final int studentId;
  final bool isSelected;

  @override
  List<Object> get props => super.props..addAll([studentId, isSelected]);
}
