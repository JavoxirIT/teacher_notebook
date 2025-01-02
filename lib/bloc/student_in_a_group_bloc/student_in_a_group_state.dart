part of 'student_in_a_group_bloc.dart';

abstract class StudentInAGroupState extends Equatable {
  const StudentInAGroupState();

  @override
  List<Object> get props => [];
}

class StudentInAGroupInitialState extends StudentInAGroupState {}

class StudentInAGroupLoadingState extends StudentInAGroupState {}

class StudentInAGroupLoadState extends StudentInAGroupState {
  final List<StudentInAGroupModels> data;
  final Map<String, Map<int, bool>> paymentStatusCache;

  const StudentInAGroupLoadState(this.data, {this.paymentStatusCache = const {}});

  StudentInAGroupLoadState copyWith({
    List<StudentInAGroupModels>? data,
    Map<String, Map<int, bool>>? paymentStatusCache,
  }) {
    return StudentInAGroupLoadState(
      data ?? this.data,
      paymentStatusCache: paymentStatusCache ?? this.paymentStatusCache,
    );
  }

  @override
  List<Object> get props => [data, paymentStatusCache];
}

class StudentInAGroupNotDataState extends StudentInAGroupState {}

class StudentInAGroupErrorState extends StudentInAGroupState {
  final Exception exception;
  const StudentInAGroupErrorState({required this.exception});

  @override
  List<Object> get props => [exception];
}

class StudentInAGroupDeleteState extends StudentInAGroupState {}
