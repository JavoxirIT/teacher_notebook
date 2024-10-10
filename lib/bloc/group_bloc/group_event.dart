part of 'group_bloc.dart';

sealed class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class GroupEventLoading extends GroupEvent {}

class GroupEventLoad extends GroupEvent {}

class GroupEventDelete extends GroupEvent {
  const GroupEventDelete(this.id);
  final int id;

  @override
  List<Object> get props => super.props..addAll([id]);
}

class GroupEventAddAndUpdate extends GroupEvent {
  const GroupEventAddAndUpdate(this.dataGroup);
  final GroupDB dataGroup;

  @override
  List<Object> get props => super.props..addAll([dataGroup]);
}
