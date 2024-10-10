import 'package:assistant/db/payments_repository.dart';
import 'package:assistant/db/models/payments_db_models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'payments_event.dart';
part 'payments_state.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  PaymentsBloc(this._paysRepository) : super(PaymentsInitial()) {
    on<PaymentsEventLoad>(_loadPaymentData);
    on<PaymentsOneStudentEventLoad>(_oneStudentPayment);
  }
  final PaysRepository _paysRepository;

  Future<void> _loadPaymentData(
      PaymentsEventLoad event, Emitter<PaymentsState> emit) async {
    try {
      final loadedPayments = await _paysRepository.queryAll();

      if (loadedPayments.isEmpty) {
        emit(PaymentsNoDataState());
      } else {
        emit(PaymentsLoadedState(loadedPayments: loadedPayments));
      }
    } on Exception catch (e) {
      emit(PaymentsErrorState(exception: e));
    }
  }

  Future<void> _oneStudentPayment(
      PaymentsOneStudentEventLoad event, Emitter<PaymentsState> emit) async {
    try {
      final loadedOnePayments = await _paysRepository.queryOne(event.id);

      if (loadedOnePayments.isEmpty) {
        emit(PaymentsNoDataState());
      } else {
        emit(PaymentsLoadedOneStudentState(
            loadedOnePayments: loadedOnePayments));
      }
    } on Exception catch (e) {
      emit(PaymentsErrorState(exception: e));
    }
  }
}
