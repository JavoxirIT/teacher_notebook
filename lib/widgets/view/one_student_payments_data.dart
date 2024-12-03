import 'package:TeamLead/bloc/payments_bloc/payments_bloc.dart';
import 'package:TeamLead/widgets/custom_container.dart';
import 'package:TeamLead/widgets/three_item_row_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OneStudentPaymentsData extends StatefulWidget {
  const OneStudentPaymentsData({super.key, required this.studentId});

  final int studentId;

  @override
  State<OneStudentPaymentsData> createState() => _OneStudentPaymentsDataState();
}

class _OneStudentPaymentsDataState extends State<OneStudentPaymentsData> {
  @override
  void initState() {
    BlocProvider.of<PaymentsBloc>(context)
        .add(PaymentsOneStudentEventLoad(id: widget.studentId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Title'),
      // ),
      body: BlocBuilder<PaymentsBloc, PaymentsState>(builder: (context, state) {
        if (state is PaymentsNoDataState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Оплат нет",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "добавьте оплату",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
          );
        }
        if (state is PaymentsLoadedOneStudentState) {
          return SingleChildScrollView(
            child: CustomContainer(
              widgets: Column(children: [
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(.5), // Первая колонка займет 1 часть
                    1: FlexColumnWidth(2), // Вторая колонка займет 2 части
                    2: FlexColumnWidth(1), // Третья колонка фиксированная
                  },
                  children: [
                    const TableRow(
                      // decoration: BoxDecoration(color: Colors.blue[100]),
                      children: [
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              '№',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              // textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Имя студента',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              // textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Сумма',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              // textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Дата',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              // textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...state.loadedOnePayments.asMap().entries.map(
                      (entry) {
                        final index = entry.key;
                        final pay = entry.value;
                        final student =
                            '${pay.studentSurName} ${pay.studentName}';

                        return threeItemRowTable(
                          context,
                          '${index + 1}',
                          student,
                          pay.payments.toString(),
                          '${pay.day}/${pay.month}/${pay.year}',
                          index % 2 == 0 ? Colors.grey[200]! : Colors.white,
                        );
                      },
                    ),
                  ],
                )
              ]),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(backgroundColor: Colors.amber),
        );
      }),
    );
  }
}
