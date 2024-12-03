import 'package:TeamLead/db/models/student_and_group_models.dart';
import 'package:TeamLead/db/student_add_group_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'student_and_group_list_event.dart';
part 'student_and_group_list_state.dart';

class StudentAndGroupListBloc
    extends Bloc<StudentAndGroupListEvent, StudentAndGroupListState> {
  StudentAndGroupListBloc(this._groupRepository)
      : super(StudentAndGroupListInitial()) {
    on<StudentAndGroupLoadEvent>(_loadStudentAndGroup);
    on<StudentAndGroupSelectionEvent>(selectedGroupStatus);
  }

  final StudentAddGroupRepository _groupRepository;

  Future<void> _loadStudentAndGroup(StudentAndGroupLoadEvent event,
      Emitter<StudentAndGroupListState> emit) async {
    try {
      final result = await _groupRepository.queryALL(event.id!);
      if (result.isEmpty) {
        emit(StudentAndGroupListInitial());
      } else {
        emit(StudentAndGroupLoadState(result));
      }
    } on Exception catch (e) {
      emit(StudentAndGroupErrorState(exception: e));
    }
  }

  Future<void> selectedGroupStatus(StudentAndGroupSelectionEvent event,
      Emitter<StudentAndGroupListState> emit) async {
    if (state is StudentAndGroupLoadState) {
      final updatedList =
          (state as StudentAndGroupLoadState).data.map((student) {
        if (student.studentsId == event.studentId) {
          return student.copyWith(isSelected: event.isSelected);
        }
        return student;
      }).toList();

      emit(StudentAndGroupLoadState(updatedList));
    }
  }
}
