import 'dart:developer';

import 'package:TeamLead/db/constants/student_data_constants.dart';
import 'package:TeamLead/db/constants/student_pays_constants.dart';
import 'package:TeamLead/db/init_db.dart';
import 'package:TeamLead/db/models/payments_db_models.dart';
import 'package:sqflite/sqflite.dart';

enum PaysRepositoryStatus {
  success,
  error,
  databaseException,
  duplicateEntry,
}

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
      // log("Ошибка в INSERT PAYMENTS: $e");
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
    // log(paymentsOne.toString());
    return paymentsOne;
  }

  // READ ALL GROUP PAYMENTS
  Future<List<PaymentsDB>> getAllGroupPayments(int groupId) async {
    paymentsList.clear();
    Database? db = await database;
    final List<Map<String, dynamic>> studentPaymentData = await db!.rawQuery(
      '''
      SELECT $paysTable.*, $studentTable.studentName, $studentTable.studentSurName 
      FROM $paysTable 
      INNER JOIN $studentTable ON $studentTable.id = $paysTable.student_id 
      WHERE $paysTable.forWhichGroupId = ?
      ORDER BY $paysTable.timestamp_seconds DESC
      ''',
      [groupId],
    );

    for (var element in studentPaymentData) {
      paymentsList.add(PaymentsDB.fromMap(element));
    }
    return paymentsList;
  }

  // Проверка оплаты студента за текущий месяц
  Future<Object> hasPaymentForCurrentMonth(
      int studentId, int? month, int? year) async {
    try {
      Database? db = await database;
      final now = DateTime.now();
      final currentMonth = now.month.toString();
      final currentYear = now.year.toString();

      final List<Map<String, dynamic>> result = await db!.query(
        paysTable,
        where: 'student_id = ? AND month = ? AND year = ?',
        whereArgs: [studentId, month ?? currentMonth, year ?? currentYear],
      );
      return result.isNotEmpty ? PaysRepositoryStatus.success : PaysRepositoryStatus.duplicateEntry;
    } on DatabaseException {
      return PaysRepositoryStatus.databaseException;
    } catch (e) {
      return PaysRepositoryStatus.error;
    }
  }

  Future<Map<String, dynamic>> getCurrentMonthPaymentsSum(
      String? months, String? years) async {
    Database? db = await database;
    final date = DateTime.now();
    if (db == null) {
      return {
        'total': 0,
        'month': int.parse(months ?? date.month.toString()),
        'year': int.parse(years ?? date.year.toString())
      };
    }

    final result = await db.rawQuery('''
      SELECT SUM($paysSumma) as total
      FROM $paysTable
      WHERE $month = ? AND $year = ?
    ''', [months ?? date.month, years ?? date.year]);
    final total = result.first['total'];

    return {
      'total': total == null ? 0 : total as int,
      'month': int.parse(months ?? date.month.toString()),
      'year': int.parse(years ?? date.year.toString())
    };
  }

//   Future<void> removeDuplicatePayments() async {
//     Database? db = await database;
//     if (db == null) return;

//     // Начинаем транзакцию
//     await db.transaction((txn) async {
//       // Находим дубликаты для student_id: 7 и 10 за декабрь 2024
//       final duplicates = await txn.rawQuery('''
//         WITH numbered AS (
//           SELECT id,
//                  ROW_NUMBER() OVER (
//                    PARTITION BY student_id, month, year
//                    ORDER BY timestamp_seconds DESC
//                  ) as rn
//           FROM $paysTable
//           WHERE student_id IN (7, 10)
//           AND month = 12
//           AND year = 2024
//         )
//         SELECT id FROM numbered WHERE rn > 1
//       ''');

//       if (duplicates.isNotEmpty) {
//         // Получаем список ID для удаления
//         final idsToDelete = duplicates.map((row) => row['id'] as int).toList();

//         // Логируем количество записей для удаления
//         log('Found ${idsToDelete.length} duplicate payments to delete');

//         // Удаляем дубликаты
//         final deletedCount = await txn.delete(
//           paysTable,
//           where: 'id IN (${idsToDelete.join(',')})',
//         );

//         log('Deleted $deletedCount duplicate payments');
//       } else {
//         log('No duplicates found');
//       }
//     });
//   }

//   Future<int> deletePaymentsByStudentIds(List<int> studentIds) async {
//     Database? db = await database;
//     if (db == null) return 0;

//     // Сначала выведем, какие записи будут удалены
//     final recordsToDelete = await db.query(
//       paysTable,
//       where: 'student_id IN (${studentIds.join(",")})',
//     );

//     log('Will delete ${recordsToDelete.length} payments:');
//     for (var record in recordsToDelete) {
//       log('Payment ID: ${record['id']}, Student ID: ${record['student_id']}, Amount: ${record['summa']}');
//     }

//     // Удаляем записи
//     final deletedCount = await db.delete(
//       paysTable,
//       where: 'student_id IN (${studentIds.join(",")})',
//     );

//     log('Deleted $deletedCount payments');
//     return deletedCount;
//   }
}
