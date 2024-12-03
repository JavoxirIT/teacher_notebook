import 'package:TeamLead/db/models/group_db_models.dart';
import 'package:TeamLead/db/new_group_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupBloc(this._groupRepository) : super(GroupInitial()) {
    on<GroupEventLoad>(_loadGroup);
    on<GroupEventDelete>(_deleteGroup);
    on<GroupEventAddAndUpdate>(_insertandUpdate);
  }
  final NewGroupRepository _groupRepository;
  late List<GroupDB> dataGroup;
  Future<void> _loadGroup(
      GroupEventLoad event, Emitter<GroupState> emit) async {
    try {
      final group = await _groupRepository.getGroup();
      // emit(GroupStateLoad(group: group));
      if (group.isEmpty) {
        emit(GroupNoDataState());
      } else {
        dataGroup = group;
        emit(GroupStateLoad(group: group));
      }
    } on Exception catch (exception) {
      emit(GroupErrorState(exception: exception));
    }
  }

  Future<void> _deleteGroup(
      GroupEventDelete event, Emitter<GroupState> emit) async {
    try {
      final group = await _groupRepository.deleteGroup(event.id);
      debugPrint('$group');

      if (group == 1) {
        emit(GroupStateLoad(group: dataGroup));
      } else if (dataGroup.isEmpty) {
        emit(GroupNoDataState());
      }
    } on Exception catch (exception) {
      emit(GroupErrorState(exception: exception));
    }
  }

  Future<void> _insertandUpdate(
      GroupEventAddAndUpdate event, Emitter<GroupState> emit) async {
    try {
      final result = await _groupRepository.insertGroup(event.dataGroup);
      final group = await _groupRepository.getGroup();
      if (result == 1) {
        emit(GroupStateLoading());
        emit(GroupStateUpdateLoad(group: group));
      }
    } on Exception catch (e) {
      emit(GroupErrorState(exception: e));
    }
  }
}
