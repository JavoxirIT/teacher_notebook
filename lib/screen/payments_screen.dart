import 'package:TeamLead/bloc/payments_bloc/payments_bloc.dart';
import 'package:TeamLead/navigation/drawer_menu.dart';
import 'package:TeamLead/style/outlone_button_light_style.dart';
import 'package:TeamLead/theme/color.dart';
import 'package:TeamLead/widgets/custom_container.dart';
import 'package:TeamLead/widgets/three_item_row_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  @override
  void initState() {
    BlocProvider.of<PaymentsBloc>(context).add(const PaymentsEventLoad());
    super.initState();
  }

  var num = 1;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle =
        Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 12.0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Все оплаты'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet(
              builder: (context) {
                return const SearchPayments();
              },
              context: context,
            ),
            icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
          ),
        ],
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
              child: Column(
            children: [
              ...state.loadedPayments.entries.map(
                (arrData) {
                  final payData = arrData.value;
                  var firstData = payData[0];
                  double paymentValue = 0;
                  for (var i in payData) {
                    paymentValue += i.payments;
                  }
                  return CustomContainer(
                    widgets: Column(
                      children: [
                        CustomContainer(
                            color: iconGreenColor,
                            mm: 0,
                            widgets: Center(
                              child: Text(
                                "Оплата(ы) за ${firstData.month}/${firstData.year}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(fontSize: 16.0),
                              ),
                            )),
                        Table(
                          columnWidths: const {
                            0: FlexColumnWidth(.5),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                          },
                          // border: TableBorder.all(),
                          children: [
                            const TableRow(
                              // decoration: BoxDecoration(color: Colors.blue[100]),
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      '№',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      // textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Ф.И',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Сумма',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      // textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Дата',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                      // textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ...payData.asMap().entries.map(
                              (entry) {
                                final index = entry.key;
                                final pay = entry.value;
                                // log('${entry.value}');
                                final student =
                                    '${pay.studentSurName} ${pay.studentName}';

                                return threeItemRowTable(
                                  context,
                                  '${index + 1}',
                                  student,
                                  pay.payments.toString(),
                                  '${pay.day}/${pay.month}/${pay.year}',
                                  index % 2 == 0 ? colorGrey200 : colorWhite,
                                );
                              },
                            ),
                          ],
                        ),
                        const Gap(10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Сумма:',
                              style: textStyle,
                            ),
                            Text(
                              NumberFormat.decimalPattern('uz')
                                  .format(paymentValue),
                              style: textStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ));
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}

class SearchPayments extends StatefulWidget {
  const SearchPayments({super.key});

  @override
  State<SearchPayments> createState() => _SearchPaymentsState();
}

class _SearchPaymentsState extends State<SearchPayments> {
  DateTime date = DateTime.now();
  String? month;
  String? year;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headlineLarge!;
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.66,
      maxChildSize: 0.96,
      snap: true,
      snapAnimationDuration: const Duration(milliseconds: 150),
      builder: (context, scrollController) {
        return Column(
          children: [
            Text(
              "Поиск оплат",
              style: textStyle,
            ),
            SizedBox(
              height: 230.0,
              child: CupertinoDatePicker(
                initialDateTime: date,
                mode: CupertinoDatePickerMode.monthYear,
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    date = newDate;
                    var info =
                        DateFormat('dd/MM/yyyy').format(newDate).split("/");
                    month = info[1];
                    year = info[2];
                  });
                },
              ),
            ),
            const Gap(10.0),
            Container(
                width: MediaQuery.of(context).size.width,
                height: 60.0,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: OutlinedButton(
                  onPressed: () {
                    var infoDate =
                        DateFormat('dd/MM/yyyy').format(date).split("/");
                    BlocProvider.of<PaymentsBloc>(context).add(
                      PaymentsEventLoad(
                        month: month ?? infoDate[1],
                        year: year ?? infoDate[2],
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  style: outlineButtonLightStyle,
                  child: Text(
                    "Поиск",
                    style: textStyle,
                  ),
                ))
          ],
        );
      },
    );
  }
}
