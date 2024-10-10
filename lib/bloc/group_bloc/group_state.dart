part of 'group_bloc.dart';

sealed class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object> get props => [];
}

final class GroupInitial extends GroupState {}

// loader
final class GroupStateLoading extends GroupState {}

// если нет данных
final class GroupNoDataState extends GroupState {}

// для получения списка груп
final class GroupStateLoad extends GroupState {
  const GroupStateLoad({
    required this.group,
  });
  final List<GroupDB> group;

  @override
  List<Object> get props => super.props..addAll([group]);
}

// ошибка при получение данных
final class GroupErrorState extends GroupState {
  const GroupErrorState({
    required this.exception,
  });
  final Exception exception;

  @override
  List<Object> get props => super.props..add(exception);
}

// при изменения данных
final class GroupStateUpdateLoad extends GroupState {
  const GroupStateUpdateLoad({
    required this.group,
  });
  final List<GroupDB> group;

  @override
  List<Object> get props => super.props..addAll([group]);
}


