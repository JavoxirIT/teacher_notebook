part of 'student_in_a_group_bloc.dart';

abstract class StudentInAGroupEvent extends Equatable {
  const StudentInAGroupEvent();

  @override
  List<Object> get props => [];
}

class LoadStudentsEvent extends StudentInAGroupEvent {
  const LoadStudentsEvent(this.id);
  final int? id;

  @override
  List<Object> get props => [id!];
}

class StudentInAGroupDeleteEvent extends StudentInAGroupEvent {
  final int id;
  final int studentId;
  const StudentInAGroupDeleteEvent({
    required this.id,
    required this.studentId,
  });

  @override
  List<Object> get props => [id, studentId];
}

class UpdatePaymentStatusesEvent extends StudentInAGroupEvent {
  final int groupId;
  final DateTime month;
  const UpdatePaymentStatusesEvent(this.groupId, this.month);

  @override
  List<Object> get props => [groupId, month];
}

class RefreshPaymentStatusesEvent extends StudentInAGroupEvent {
  final int groupId;
  final DateTime month;
  const RefreshPaymentStatusesEvent(this.groupId, this.month);

  @override
  List<Object> get props => [groupId, month];
}
