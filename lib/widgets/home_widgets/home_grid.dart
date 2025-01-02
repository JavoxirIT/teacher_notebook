import 'package:TeamLead/constants/route_name/route_name.dart';
import 'package:TeamLead/db/payments_repository.dart';
import 'package:TeamLead/widgets/show_cupertino_modal_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class HomeGrid extends StatefulWidget {
  const HomeGrid({
    super.key,
    required this.stCount,
    required this.numberOfPaid,
    required this.numberNotOfPaid,
    required this.currentMonthTotalPayments,
  });

  final int stCount;
  final int numberOfPaid;
  final int numberNotOfPaid;
  final Map<String, dynamic> currentMonthTotalPayments;

  @override
  State<HomeGrid> createState() => _HomeGridState();
}

class _HomeGridState extends State<HomeGrid> {
  DateTime date = DateTime.now();
  int? month;
  int? year;
  int? payd;

  @override
  void initState() {
    super.initState();
    payd = widget.currentMonthTotalPayments['total'] as int;
    month = widget.currentMonthTotalPayments['month'] as int;
    year = widget.currentMonthTotalPayments['year'] as int;
  }

  @override
  void didUpdateWidget(HomeGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentMonthTotalPayments !=
        widget.currentMonthTotalPayments) {
      payd = widget.currentMonthTotalPayments['total'] as int;
      month = widget.currentMonthTotalPayments['month'] as int;
      year = widget.currentMonthTotalPayments['year'] as int;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.5,
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 5,
        mainAxisExtent: 100,
      ),
      children: [
        GridItem(
          title: 'Ученики',
          subTitle: widget.stCount.toString(),
        ),
        GridItem(
          title: 'Бесплатно',
          subTitle: widget.numberNotOfPaid.toString(),
        ),
        GridItem(
          title: 'Платно',
          subTitle: widget.numberOfPaid.toString(),
        ),
        InkWell(
          onTap: () {
            cupertinoShow(updateData, month, year);
          },
          child: GridItem(
            title: "Оплата за месяц ${month.toString().padLeft(2, '0')}.$year",
            subTitle: NumberFormat('#,###').format(payd ?? 0),
          ),
        ),
      ],
    );
  }

  void updateData(String m, String y) async {
    final result = await PaysRepository.db
        .getCurrentMonthPaymentsSum(m.toString(), y.toString());

    if (mounted) {
      setState(() {
        month = result['month'] as int;
        year = result['year'] as int;
        payd = result['total'] as int;
      });
    }
  }

  cupertinoShow(updateData, month, year) async {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Таблица оплат'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(RouteName.paymentsScreen);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Оплата за'),
            onPressed: () {
              show(updateData, month, year);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
      ),
    );
  }

  Future<void> show(updateData, month, year) {
    return showCupModalPopup(
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2E3192), // Темно-синий
                Color(0xFF1BFFFF), // Голубой
              ],
            ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(51), // 0.2 * 255 ≈ 51
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Полоска для drag
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(77), // 0.3 * 255 ≈ 77
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Заголовок
              Gap(30),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withAlpha(51), // 0.2 * 255 ≈ 51
                      Colors.white.withAlpha(26), // 0.1 * 255 ≈ 26
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withAlpha(51), // 0.2 * 255 ≈ 51
                    width: 1,
                  ),
                ),
                child: CupertinoTheme(
                  data: const CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    backgroundColor: Colors.transparent,
                    initialDateTime: date,
                    mode: CupertinoDatePickerMode.monthYear,
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        date = newDate;
                        var info =
                            DateFormat('MM/yyyy').format(newDate).split("/");
                        month = int.parse(info[0]);
                        year = int.parse(info[1]);
                      });
                    },
                  ),
                ),
              ),
              // Кнопки
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(51), // 0.2 * 255 ≈ 51
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  Colors.white.withAlpha(51), // 0.2 * 255 ≈ 51
                              width: 1,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Отмена',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF00C6FF), // Голубой
                                Color(0xFF0072FF), // Синий
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0072FF)
                                    .withAlpha(77), // 0.3 * 255 ≈ 77
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'Применить',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () {
                          updateData(month.toString(), year.toString());
                          Navigator.pop(context);
                          Navigator.pop(context);
                          // Здесь можно добавить логику обработки выбранной даты
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
        context,
        500);
  }
}

class GridItem extends StatelessWidget {
  const GridItem({
    super.key,
    required this.title,
    required this.subTitle,
  });

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title),
            Text(subTitle),
          ],
        ),
      ),
    );
  }
}
