import 'package:assistant/db/models/student_in_a_group_models.dart';
import 'package:assistant/db/student_add_group_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'student_in_a_group_event.dart';
part 'student_in_a_group_state.dart';

class StudentInAGroupBloc
    extends Bloc<StudentInAGroupBlockEvent, StudentInAGroupBlockState> {
  StudentInAGroupBloc(this._groupRepository)
      : super(StudentInAGroupBlockInitial()) {
    on<StudentInAGroupBlockEvent>((event, emit) {
            on<StudentInAGroupEvent>(_studentInAGroup);
    });
  }

  final StudentAddGroupRepository _groupRepository;

  Future<void> _studentInAGroup(StudentInAGroupEvent event,
      Emitter<StudentInAGroupBlockState> emit) async {
    try {
      final result = await _groupRepository.queryOneGroup(event.id!);
      if (result.isEmpty) {
        emit(StudentInAGroupNotDataState());
      } else {
        emit(StudentInAGroupLoadState(result));
      }
    } on Exception catch (e) {
      emit(StudentInAGroupErrorState(exception: e));
    }
  }
}
