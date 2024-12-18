import 'dart:developer';

import 'package:TeamLead/db/constants/student_data_constants.dart';
import 'package:TeamLead/db/constants/student_pays_constants.dart';
import 'package:TeamLead/db/init_db.dart';
import 'package:TeamLead/db/models/payments_db_models.dart';
import 'package:sqflite/sqflite.dart';

class PaysRepository extends InitDB {
  static final PaysRepository db = PaysRepository();

  late final List<PaymentsDB> paymentsList = [];
  late final List<PaymentsDB> paymentsOne = [];

  // INSERT PAYMENTS
  Future<String> insertStudentPayments(PaymentsDB payment) async {
    try {
      Database? db = await database;
      payment.paysId = await db!.insert(paysTable, payment.toMap());
      log('insertStudentPayments: $payment');
      if (payment.paysId != null) {
        return "success";
      }
      return "error";
    } catch (e) {
      log("Ошибка в INSERT PAYMENTS: $e");
      throw Exception("Ошибка в INSERT PAYMENTS: $e");
    }
  }

  // READ ALL
  // Future<List<PaymentsDB>> queryAll() async {
  //   paymentsList.clear();
  //   Database? db = await database;
  //   final List<Map<String, dynamic>> studentPaymentData = await db!.rawQuery(
  //     'SELECT  $studentTable.studentName, $studentTable.studentSurName, $paysTable.student_id, $paysTable.summa, $paysTable.day, $paysTable.month, $paysTable.year, $paysTable.id  FROM $paysTable inner join $studentTable  on  $studentTable.id = $paysTable.student_id',
  //   );

  //   for (var element in studentPaymentData) {
  //     paymentsList.add(PaymentsDB.fromMap(element));
  //   }
  //   return paymentsList;
  // }
// READ ALL on sord date
  Future<Map<String, List<PaymentsDB>>> queryAll(
      [String? month, String? year]) async {
    paymentsList.clear();
    Database? db = await database;
    // Получаем текущий месяц и год
    final DateTime now = DateTime.now();
    final String currentMonth = now.month.toString();
    final String currentYear = now.year.toString();

    // Создаем базовый SQL-запрос
    String sql = '''
    SELECT  
      $studentTable.studentName, 
      $studentTable.studentSurName, 
      $paysTable.student_id, 
      $paysTable.summa, 
      $paysTable.day, 
      $paysTable.month, 
      $paysTable.year, 
      $paysTable.id  
    FROM $paysTable 
    INNER JOIN $studentTable  
    ON $studentTable.id = $paysTable.student_id
  ''';

    // Добавляем условия для month и year, если они переданы
    List<dynamic> parameters = [];
    if (month != null && year != null) {
      sql += ' WHERE $paysTable.month = ? AND $paysTable.year = ?';
      parameters.addAll([month, year]);
    }

    // Добавляем сортировку
    sql += '''
    ORDER BY 
      CASE 
        WHEN $paysTable.month = ? AND $paysTable.year = ? THEN 0
        ELSE 1
      END,
      $paysTable.year DESC, 
      $paysTable.month DESC, 
      $paysTable.day DESC
  ''';

    // Добавляем текущий месяц и год как параметры сортировки
    parameters.addAll([currentMonth, currentYear]);

    // Выполняем запрос
    final List<Map<String, dynamic>> filteredData =
        await db!.rawQuery(sql, parameters);

    // Группируем данные
    Map<String, List<PaymentsDB>> groupedData = {};

    for (var element in filteredData) {
      // Создаем ключ на основе даты
      String key = "${element['month']}-${element['year']}";

      // Преобразуем элемент в объект PaymentsDB
      PaymentsDB payment = PaymentsDB.fromMap(element);

      // Добавляем объект в соответствующую группу
      if (groupedData.containsKey(key)) {
        groupedData[key]!.add(payment);
      } else {
        groupedData[key] = [payment];
      }
    }
    // log('groupedData: $groupedData');
    return groupedData;
  }

  Future<List<PaymentsDB>> queryOne(int id) async {
    log('PaymentsDB, $id');
    paymentsOne.clear();
    Database? db = await database;
    final List<Map<String, dynamic>> studentPaymentData = await db!.rawQuery(
      'SELECT  $studentTable.studentName, $studentTable.studentSurName, $paysTable.student_id, $paysTable.summa, $paysTable.day, '
      '$paysTable.month, $paysTable.year, '
      '$paysTable.id  FROM $paysTable inner join $studentTable  on  $studentTable.id = $paysTable.student_id where  $paysTable.student_id = $id',
    );

    for (var element in studentPaymentData) {
      paymentsOne.add(PaymentsDB.fromMap(element));
    }
    log(paymentsOne.toString());
    return paymentsOne;
  }
}
