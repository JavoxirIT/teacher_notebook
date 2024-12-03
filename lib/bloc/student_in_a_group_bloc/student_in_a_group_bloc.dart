import 'dart:developer';

import 'package:TeamLead/db/models/student_in_a_group_models.dart';
import 'package:TeamLead/db/student_add_group_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'student_in_a_group_event.dart';
part 'student_in_a_group_state.dart';

class StudentInAGroupBloc
    extends Bloc<StudentInAGroupBlockEvent, StudentInAGroupBlockState> {
  StudentInAGroupBloc(this._groupRepository)
      : super(StudentInAGroupBlockInitial()) {
    on<StudentInAGroupEvent>(_studentInAGroup);
    on<StudentInAGroupDeleteEvent>(deleteStudentFromGroup);
    on<StudentInAGroupEventInitial>(changeState);
  }

  final StudentAddGroupRepository _groupRepository;

  Future<void> _studentInAGroup(StudentInAGroupEvent event,
      Emitter<StudentInAGroupBlockState> emit) async {
    try {
      final result = await _groupRepository.queryOneGroup(event.id!);
      // log('$result');
      if (result.isEmpty) {
        emit(StudentInAGroupNotDataState());
      } else {
        emit(StudentInAGroupLoadState(result));
      }
    } on Exception catch (e) {
      emit(StudentInAGroupErrorState(exception: e));
    }
  }

  Future<void> deleteStudentFromGroup(StudentInAGroupDeleteEvent event,
      Emitter<StudentInAGroupBlockState> emit) async {
    try {
      final result =
          _groupRepository.deleteStudentFromGroup(event.id, event.studentId);
      log('delete user from group $result');
    } on Exception catch (e) {
      log('delete user in a group error: $e');
    }
  }

  Future<void> changeState(StudentInAGroupEventInitial event,
      Emitter<StudentInAGroupBlockState> emit) async {
    emit(StudentInAGroupNotDataState());
  }
}
