import 'package:TeamLead/db/models/student_bd_models.dart';
import 'package:TeamLead/db/student_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  StudentBloc(this._dbProvider) : super(StudentInitialState()) {
    on<StudentEventLoad>(_loadStudet);
    on<StudentEventSearch>(_searchStudenet);
  }
  final StudentRepository _dbProvider;

  @override
  Future<void> close() {
    // Закрыть все стримы и освободить ресурсы
    return super.close();
  }

  Future<void> _loadStudet(
      StudentEventLoad event, Emitter<StudentState> emit) async {
    try {
      final loadedStudent = await _dbProvider.getStudents();

      if (loadedStudent.isEmpty) {
        emit(StudentNoDataState());
      } else {
        emit(StudentLoadedState(
          loadedStudent: loadedStudent,
        ));
      }
    } on Exception catch (e) {
      emit(StudentErrorState(exception: e));
    }
  }

  Future<void> _searchStudenet(
      StudentEventSearch event, Emitter<StudentState> emit) async {
      final search = await _dbProvider.searchStudent(event.searchText);
    // if (search.isEmpty) {
    //   emit(StudentSearchNoDataState());
    // }
      if (search.isNotEmpty) {
        emit(StudentLoadedState(
          loadedStudent: search,
        ));
    }
  }
}
