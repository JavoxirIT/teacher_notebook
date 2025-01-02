import 'package:TeamLead/db/models/payments_db_models.dart';
import 'package:TeamLead/db/payments_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupPaymentsHistory extends StatefulWidget {
  final int groupId;
  final String groupName;

  const GroupPaymentsHistory({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  State<GroupPaymentsHistory> createState() => _GroupPaymentsHistoryState();
}

class _GroupPaymentsHistoryState extends State<GroupPaymentsHistory> {
  final Map<String, List<PaymentsDB>> _paymentsByMonth = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  Future<void> _loadPayments() async {
    setState(() {
      _isLoading = true;
      _paymentsByMonth.clear(); // Очищаем map перед загрузкой новых данных
    });

    try {
      final payments = await PaysRepository.db.getAllGroupPayments(widget.groupId);
      
      // Группируем платежи по месяцам
      final Map<String, List<PaymentsDB>> newPayments = {};  // Создаем новый map
      for (var payment in payments) {
        final key = '${payment.month}-${payment.year}';
        if (!newPayments.containsKey(key)) {
          newPayments[key] = [];
        }
        newPayments[key]!.add(payment);
      }

      // Сортируем месяцы в обратном порядке
      final sortedKeys = newPayments.keys.toList()
        ..sort((a, b) {
          final aDate = DateTime(
            int.parse(a.split('-')[1]),
            int.parse(a.split('-')[0]),
          );
          final bDate = DateTime(
            int.parse(b.split('-')[1]),
            int.parse(b.split('-')[0]),
          );
          return bDate.compareTo(aDate);
        });

      final sortedMap = {
        for (var key in sortedKeys) key: newPayments[key]!,
      };
      
      setState(() {
        _paymentsByMonth.addAll(sortedMap);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки данных: $e')),
      );
    }
  }

  String _getMonthName(String month) {
    final monthNumber = int.parse(month);
    final date = DateTime(2024, monthNumber);
    return DateFormat('MMMM', 'ru').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('История оплат: ${widget.groupName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPayments,
            tooltip: 'Обновить',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _paymentsByMonth.isEmpty
              ? const Center(
                  child: Text(
                    'Нет данных об оплатах',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: _paymentsByMonth.length,
                  itemBuilder: (context, index) {
                    final monthKey = _paymentsByMonth.keys.elementAt(index);
                    final payments = _paymentsByMonth[monthKey]!;
                    final month = monthKey.split('-')[0];
                    final year = monthKey.split('-')[1];
                    final totalAmount = payments.fold<int>(
                      0,
                      (sum, payment) => sum + payment.payments,
                    );

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ExpansionTile(
                        title: Text(
                          '${_getMonthName(month)} $year',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          'Всего: $totalAmount сум',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: payments.length,
                            itemBuilder: (context, i) {
                              final payment = payments[i];
                              return ListTile(
                                leading: const Icon(Icons.payment),
                                title: Text('${payment.studentName} ${payment.studentSurName}'),
                                subtitle: Text('Дата: ${payment.day}.${payment.month}.${payment.year}'),
                                trailing: Text(
                                  '${payment.payments} сум',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
