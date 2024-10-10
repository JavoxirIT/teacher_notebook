part of 'student_bloc.dart';

sealed class StudentEvent extends Equatable {
  const StudentEvent();

  @override
  List<Object> get props => [];
}

class StudentEventLoad extends StudentEvent {}

class StudentEventAdd extends StudentEvent {}

class StudentEventDelete extends StudentEvent {}

class StudentEventUpdate extends StudentEvent {}

class StudentEventSearch extends StudentEvent {
  const StudentEventSearch({
    required this.searchText,
  });
  final String searchText;

  @override
  List<Object> get props => super.props..addAll([searchText]);
}
