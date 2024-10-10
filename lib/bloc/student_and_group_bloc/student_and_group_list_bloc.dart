import 'package:assistant/db/models/student_and_group_models.dart';
import 'package:assistant/db/models/student_in_a_group_models.dart';
import 'package:assistant/db/student_add_group_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'student_and_group_list_event.dart';
part 'student_and_group_list_state.dart';

class StudentAndGroupListBloc
    extends Bloc<StudentAndGroupListEvent, StudentAndGroupListState> {
  StudentAndGroupListBloc(this._groupRepository)
      : super(StudentAndGroupListInitial()) {
    on<StudentAndGroupLoadEvent>(_loadStudentAndGroup);
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
}
