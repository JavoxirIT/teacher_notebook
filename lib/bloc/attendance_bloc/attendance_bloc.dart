import 'package:TeamLead/db/attendance_repository.dart';
import 'package:TeamLead/db/models/attendance_db_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart'; // Add this import

// Events
abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => [];
}

class LoadGroupAttendance extends AttendanceEvent {
  final int groupId;
  final String date;

  const LoadGroupAttendance(this.groupId, this.date);

  @override
  List<Object?> get props => [groupId, date];
}

class LoadMonthlyAttendance extends AttendanceEvent {
  final int groupId;
  final DateTime month;

  const LoadMonthlyAttendance(this.groupId, this.month);

  @override
  List<Object?> get props => [groupId, month];
}

class MarkAttendance extends AttendanceEvent {
  final AttendanceDB attendance;

  const MarkAttendance(this.attendance);

  @override
  List<Object?> get props => [attendance];
}

// States
abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final List<AttendanceDB> attendanceRecords;

  const AttendanceLoaded(this.attendanceRecords);

  @override
  List<Object?> get props => [attendanceRecords];
}

class MonthlyAttendanceLoaded extends AttendanceState {
  final List<AttendanceDB> attendanceRecords;

  const MonthlyAttendanceLoaded(this.attendanceRecords);

  @override
  List<Object?> get props => [attendanceRecords];
}

class AttendanceError extends AttendanceState {
  final String message;

  const AttendanceError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepository _repository;

  AttendanceBloc(this._repository) : super(AttendanceInitial()) {
    on<LoadGroupAttendance>(_onLoadGroupAttendance);
    on<LoadMonthlyAttendance>(_onLoadMonthlyAttendance);
    on<MarkAttendance>(_onMarkAttendance);
  }

  Future<void> _onLoadGroupAttendance(
    LoadGroupAttendance event,
    Emitter<AttendanceState> emit,
  ) async {
    try {
      emit(AttendanceLoading());
      // debugPrint('Loading attendance for group ${event.groupId} on ${event.date}');
      final data = await _repository.getGroupAttendance(event.groupId, event.date);
      // debugPrint('Loaded ${data.length} attendance records');
      emit(AttendanceLoaded(data));
    } catch (e) {
      // debugPrint('Error loading attendance: $e');
      emit(AttendanceError(e.toString()));
    }
  }

  Future<void> _onLoadMonthlyAttendance(
    LoadMonthlyAttendance event,
    Emitter<AttendanceState> emit,
  ) async {
    try {
      emit(AttendanceLoading());
      // debugPrint('Loading monthly attendance for group ${event.groupId}');
      final yearMonth = DateFormat('yyyy-MM').format(event.month);
      final data = await _repository.getMonthlyGroupAttendance(event.groupId, yearMonth);
      // debugPrint('Loaded ${data.length} monthly attendance records');
      emit(MonthlyAttendanceLoaded(data));
    } catch (e) {
      // debugPrint('Error loading monthly attendance: $e');
      emit(AttendanceError(e.toString()));
    }
  }

  Future<void> _onMarkAttendance(
    MarkAttendance event,
    Emitter<AttendanceState> emit,
  ) async {
    try {
      final result = await _repository.insertAttendance(event.attendance);
      if (result == "success") {
        // Обновляем данные за день
        add(LoadGroupAttendance(
          event.attendance.groupId,
          event.attendance.date,
        ));
        
        // Если текущее состояние - месячный просмотр, обновляем и его
        if (state is MonthlyAttendanceLoaded) {
          final date = DateTime.parse(event.attendance.date);
          add(LoadMonthlyAttendance(event.attendance.groupId, date));
        }
      } else {
        emit(AttendanceError("Не удалось отметить посещаемость"));
      }
    } catch (e) {
      emit(AttendanceError(e.toString()));
    }
  }
}
