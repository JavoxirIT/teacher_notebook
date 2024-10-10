import 'package:assistant/bloc/payments_bloc/payments_bloc.dart';
import 'package:assistant/navigation/drawer_menu.dart';
import 'package:assistant/widgets/three_item_row_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({Key? key}) : super(key: key);

  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  @override
  void initState() {
    BlocProvider.of<PaymentsBloc>(context).add(PaymentsEventLoad());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Все оплаты'),
        centerTitle: true,
      ),
      drawer: const DrawerMenu(),
      body: BlocBuilder<PaymentsBloc, PaymentsState>(builder: (context, state) {
        if (state is PaymentsNoDataState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Список пуст",
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

        if (state is PaymentsLoadedState) {
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
                  children: state.loadedPayments.map(
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
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
