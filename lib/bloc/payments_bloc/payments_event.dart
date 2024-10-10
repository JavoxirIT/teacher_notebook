part of 'payments_bloc.dart';

sealed class PaymentsEvent extends Equatable {
  const PaymentsEvent();

  @override
  List<Object> get props => [];
}

class PaymentsEventLoad extends PaymentsEvent {}

// для загрузки плотежей от одного пользователя
class PaymentsOneStudentEventLoad extends PaymentsEvent {
  const PaymentsOneStudentEventLoad({
    required this.id,
  });
  final int id;

  @override
  List<Object> get props => super.props..addAll([id]);
}
