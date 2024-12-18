part of 'payments_bloc.dart';

sealed class PaymentsEvent extends Equatable {
  const PaymentsEvent();

  @override
  List<Object> get props => [];
}

// для загрузки плотежей от одного пользователя
class PaymentsOneStudentEventLoad extends PaymentsEvent {
  const PaymentsOneStudentEventLoad({
    required this.id,
  });
  final int id;

  @override
  List<Object> get props => super.props..addAll([id]);
}

class PaymentsEventLoad extends PaymentsEvent {
  const PaymentsEventLoad({this.month, this.year});
  final String? month;
  final String? year;

  @override
  List<Object> get props => super.props..addAll([month!, year!]);
}

class PaymentsEventInitial extends PaymentsEvent {}
