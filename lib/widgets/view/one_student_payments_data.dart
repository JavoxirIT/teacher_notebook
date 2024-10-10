import 'package:assistant/bloc/payments_bloc/payments_bloc.dart';
import 'package:assistant/widgets/three_item_row_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OneStudentPaymentsData extends StatefulWidget {
  const OneStudentPaymentsData(this._studentId);
  final int _studentId;
  @override
  _OneStudentPaymentsDataState createState() => _OneStudentPaymentsDataState();
}

class _OneStudentPaymentsDataState extends State<OneStudentPaymentsData> {
  @override
  void initState() {
    BlocProvider.of<PaymentsBloc>(context)
        .add(PaymentsOneStudentEventLoad(id: widget._studentId));
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
                  "Оплат нет...",
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
        if(state is PaymentsLoadedOneStudentState){
           return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(children: [
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    threeItemRowTable(
                      context,
                      "Фамилия Имя",
                      "Сумма оплаты",
                      "М.Ч.ГГ",
                    )
                  ],
                ),
                Table(
                  border: TableBorder.all(),
                  children: state.loadedOnePayments.map(
                    (pay) {
                      final student =
                          '${pay.studentSurName} ${pay.studentName}';

                      return threeItemRowTable(context, student,
                          pay.paysSumma.toString(), pay.paysDate);
                    },
                  ).toList(),
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
