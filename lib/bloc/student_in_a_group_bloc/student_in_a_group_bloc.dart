import 'dart:developer';

import 'package:TeamLead/db/models/student_in_a_group_models.dart';
import 'package:TeamLead/db/payments_repository.dart';
import 'package:TeamLead/db/student_add_group_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'student_in_a_group_event.dart';
part 'student_in_a_group_state.dart';

class StudentInAGroupBloc
    extends Bloc<StudentInAGroupEvent, StudentInAGroupState> {
  final StudentAddGroupRepository _groupRepository;

  StudentInAGroupBloc(this._groupRepository)
      : super(StudentInAGroupInitialState()) {
    on<LoadStudentsEvent>(_onLoadStudents);
    on<StudentInAGroupDeleteEvent>(_onDeleteStudent);
    on<UpdatePaymentStatusesEvent>(_onUpdatePaymentStatuses);
    on<RefreshPaymentStatusesEvent>(_onRefreshPaymentStatuses);
  }

  Future<void> _onLoadStudents(
    LoadStudentsEvent event,
    Emitter<StudentInAGroupState> emit,
  ) async {
    try {
      emit(StudentInAGroupLoadingState());
      final result = await _groupRepository.queryOneGroup(event.id!);
      final sortedData = List<StudentInAGroupModels>.from(result)
        ..sort((a, b) => a.studentName.compareTo(b.studentName));

      if (result.isEmpty) {
        emit(StudentInAGroupNotDataState());
      } else {
        emit(StudentInAGroupLoadState(sortedData));
      }
    } on Exception catch (e) {
      emit(StudentInAGroupErrorState(exception: e));
    }
  }

  Future<void> _onDeleteStudent(
    StudentInAGroupDeleteEvent event,
    Emitter<StudentInAGroupState> emit,
  ) async {
    try {
      await _groupRepository.deleteStudentFromGroup(event.id, event.studentId);
      final students = await _groupRepository.queryOneGroup(event.id);
      if (students.isEmpty) {
        emit(StudentInAGroupNotDataState());
      } else {
        emit(StudentInAGroupLoadState(students));
      }
    } on Exception catch (e) {
      emit(StudentInAGroupErrorState(exception: e));
    }
  }

  Future<void> _onUpdatePaymentStatuses(
    UpdatePaymentStatusesEvent event,
    Emitter<StudentInAGroupState> emit,
  ) async {
    if (state is StudentInAGroupLoadState) {
      final currentState = state as StudentInAGroupLoadState;
      final monthKey = '${event.month.month}-${event.month.year}';
      
      try {
        final newCache = Map<String, Map<int, bool>>.from(currentState.paymentStatusCache);
        newCache[monthKey] = {};

        for (var student in currentState.data) {
          final hasPaid = await PaysRepository.db.hasPaymentForCurrentMonth(
            student.studentId,
            event.month.month,
            event.month.year,
          );
          // newCache[monthKey]![student.studentId] = hasPaid;
        }

        emit(currentState.copyWith(paymentStatusCache: newCache));
      } catch (e) {
        debugPrint('Ошибка при обновлении статусов оплаты: $e');
      }
    }
  }

  Future<void> _onRefreshPaymentStatuses(
    RefreshPaymentStatusesEvent event,
    Emitter<StudentInAGroupState> emit,
  ) async {
    if (state is StudentInAGroupLoadState) {
      final currentState = state as StudentInAGroupLoadState;
      final monthKey = '${event.month.month}-${event.month.year}';
      
      // Очищаем кэш для указанного месяца
      final newCache = Map<String, Map<int, bool>>.from(currentState.paymentStatusCache)
        ..remove(monthKey);
      
      emit(currentState.copyWith(paymentStatusCache: newCache));
      
      // Запускаем обновление статусов
      add(UpdatePaymentStatusesEvent(event.groupId, event.month));
    }
  }
}
