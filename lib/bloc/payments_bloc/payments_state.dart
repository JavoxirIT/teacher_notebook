part of 'payments_bloc.dart';

sealed class PaymentsState extends Equatable {
  const PaymentsState();

  @override
  List<Object> get props => [];
}

final class PaymentsInitial extends PaymentsState {}

// при загрузкой данных
class PaymentsLoadingState extends PaymentsState {}

// ошибка при получение данных
final class PaymentsNoDataState extends PaymentsState {}

// после получения данных
final class PaymentsLoadedState extends PaymentsState {
  const PaymentsLoadedState({
    required this.loadedPayments,
  });
  final Map<String, List<PaymentsDB>> loadedPayments;

  @override
  List<Object> get props => super.props..add(loadedPayments);
}

// ошибка при получение данных
final class PaymentsErrorState extends PaymentsState {
  const PaymentsErrorState({
    required this.exception,
  });
  final Exception exception;

  @override
  List<Object> get props => super.props..add(exception);
}

// для получение данных одного пользователя
final class PaymentsLoadedOneStudentState extends PaymentsState {
  const PaymentsLoadedOneStudentState({
    required this.loadedOnePayments,
  });
  final List<PaymentsDB> loadedOnePayments;

  @override
  List<Object> get props => super.props..add(loadedOnePayments);
}
