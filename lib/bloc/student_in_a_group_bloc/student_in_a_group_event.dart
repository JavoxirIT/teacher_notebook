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
