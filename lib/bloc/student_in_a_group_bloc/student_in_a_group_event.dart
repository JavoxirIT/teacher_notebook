part of 'student_in_a_group_bloc.dart';

sealed class StudentInAGroupBlockEvent extends Equatable {
  const StudentInAGroupBlockEvent();

  @override
  List<Object> get props => [];
}

class StudentInAGroupEvent extends StudentInAGroupBlockEvent {
  const StudentInAGroupEvent(this.id);
  final int? id;

  @override
  List<Object> get props => super.props..addAll([id!]);
}

class StudentInAGroupDeleteEvent extends StudentInAGroupBlockEvent {
  const StudentInAGroupDeleteEvent({required this.id, required this.studentId});
  final int id;
  final int studentId;

  @override
  List<Object> get props => super.props..addAll([id, studentId]);
}

class StudentInAGroupEventInitial extends StudentInAGroupBlockEvent {}
