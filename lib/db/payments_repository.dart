import 'package:assistant/db/constants/student_data_constants.dart';
import 'package:assistant/db/constants/student_pays_constants.dart';
import 'package:assistant/db/init_db.dart';
import 'package:assistant/db/models/payments_db_models.dart';
import 'package:sqflite/sqflite.dart';

class PaysRepository extends InitDB {
  static final PaysRepository db = PaysRepository();

  late final List<PaymentsDB> paymentsList = [];
  late final List<PaymentsDB> paymentsOne = [];

  // INSERT PAYMENTS
  Future<PaymentsDB> insertStudentPayments(PaymentsDB payment) async {
    Database? db = await database;
    payment.paysId = await db!.insert(paysTable, payment.toMap());
    return payment;
  }

  // READ ALL
  Future<List<PaymentsDB>> queryAll() async {
    paymentsList.clear();
    Database? db = await database;
    final List<Map<String, dynamic>> studentPaymentData = await db!.rawQuery(
        'SELECT  $studentTable.studentName, $studentTable.studentSurName, $paysTable.student_id, $paysTable.summa, $paysTable.date, $paysTable.id  FROM $paysTable inner join $studentTable  on  $studentTable.id = $paysTable.student_id');

    for (var element in studentPaymentData) {
      paymentsList.add(PaymentsDB.fromMap(element));
    }
    return paymentsList;
  }

  Future<List<PaymentsDB>> queryOne(int id) async {
    paymentsOne.clear();
    Database? db = await database;
    final List<Map<String, dynamic>> studentPaymentData = await db!.rawQuery(
        'SELECT  $studentTable.studentName, $studentTable.studentSurName, $paysTable.student_id, $paysTable.summa, $paysTable.date, $paysTable.id  FROM $paysTable inner join $studentTable  on  $studentTable.id = $paysTable.student_id where  $paysTable.student_id = $id');

    for (var element in studentPaymentData) {
      paymentsOne.add(PaymentsDB.fromMap(element));
    }
    return paymentsOne;
  }
}
