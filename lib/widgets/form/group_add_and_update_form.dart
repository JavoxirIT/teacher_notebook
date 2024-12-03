import 'package:TeamLead/bloc/group_bloc/group_bloc.dart';
import 'package:TeamLead/db/models/group_db_models.dart';
import 'package:TeamLead/style/clear_button_style.dart';
import 'package:TeamLead/widgets/show_cupertino_modal_popup.dart';
import 'package:TeamLead/widgets/show_snak_bar.dart';
import 'package:TeamLead/widgets/table_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupAddForm extends StatefulWidget {
  const GroupAddForm({super.key});

  @override
  State<GroupAddForm> createState() => _GroupAddFormState();
}

class _GroupAddFormState extends State<GroupAddForm> {
  Duration duration = const Duration(hours: 10, minutes: 00);
  final _formKey = GlobalKey<FormState>();
  final _groupName = TextEditingController();
  final _groupTime = TextEditingController();
  final _groupPrice = TextEditingController();
  // final _groupDays = TextEditingController();
  int? _groupDays;
  int? _groupId;

  late GroupDB _groupData;

  @override
  void didChangeDependencies() {
    RouteSettings setting = ModalRoute.of(context)!.settings;
    if (setting.arguments != null) {
      _groupData = setting.arguments as GroupDB;
      _groupName.text = _groupData.groupName;
      _groupTime.text = _groupData.groupTimes;
      _groupPrice.text = _groupData.groupPrice.toString();
      _groupDays = _groupData.groupDays;
      _groupId = _groupData.id;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextFormField(
                        controller: _groupName,
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: "Название группы",
                          suffixIcon: GestureDetector(
                            child: const Icon(Icons.delete_forever),
                            onTap: () {
                              _groupName.clear();
                            },
                          ),
                        ),
                        validator: (value) =>
                            value == "" ? "Заполните поле" : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextFormField(
                        controller: _groupTime,
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: "Время занятия",
                          suffixIcon: GestureDetector(
                            child: const Icon(Icons.delete_forever),
                            onTap: () {
                              _groupTime.clear();
                            },
                          ),
                        ),
                        onTap: () {
                          showCupModalPopup(
                              CupertinoTimerPicker(
                                initialTimerDuration: duration,
                                mode: CupertinoTimerPickerMode.hm,
                                onTimerDurationChanged: (time) {
                                  setState(() {
                                    _groupTime.text =
                                        '${time.inHours}:${time.inMinutes % 60}';
                                  });
                                },
                              ),
                              context,
                              400);
                        },
                        keyboardType: TextInputType.datetime,
                        validator: (value) =>
                            value == "" ? "Заполните поле" : null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextFormField(
                        controller: _groupPrice,
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: "Стоимость занятия",
                          suffixIcon: GestureDetector(
                            child: const Icon(Icons.delete_forever),
                            onTap: () {
                              _groupPrice.clear();
                              // debugPrint("delete");
                            },
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value == "" ? "Заполните поле" : null,
                      ),
                    ),
                    SegmentedButton(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(value: 1, label: Text("ПН-СР-ПТ")),
                        ButtonSegment(value: 0, label: Text("ВТ-ЧТ-СУ")),
                      ],
                      selected: {_groupDays},
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          _groupDays = newSelection.first;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.blue; // Цвет для выбранного состояния
                          }
                          return Colors
                              .grey[200]; // Цвет для обычного состояния
                        }),
                        foregroundColor:
                            WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors
                                .white; // Цвет текста для выбранного состояния
                          }
                          return Colors
                              .black; // Цвет текста для обычного состояния
                        }),
                        overlayColor: WidgetStateProperty.all(
                            Colors.blue.withOpacity(0.2)), // Цвет при нажатии
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Радиус углов
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: OutlinedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _showDialog(context);
                      } else {
                        showSnackInfoBar(context, 'С начала добавьте данные');
                      }
                    },
                    child: const Text("Добавить"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDialog(
    BuildContext context,
  ) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        String groupDays = _groupDays == "1" ? "ПН-СР-ПТ" : "ВТ-ЧТ-СУ";
        return AlertDialog(
          title: const Text(
            "Пожалуйста проверте данные!",
          ),
          content: SizedBox(
            width: double.maxFinite,
            // height: double.minPositive,
            // height: MediaQuery.of(context).size.height/1.5,
            child: Table(
              // shrinkWrap: true,
              children: <TableRow>[
                tableRow(context, "Название группы", _groupName.text),
                tableRow(context, "Время занятия", _groupTime.text),
                tableRow(context, "Стоимость занятия", _groupPrice.text),
                tableRow(context, "Дни занятия", groupDays),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: clearButtonStyle,
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Нет"),
            ),
            ElevatedButton(
              onPressed: () {
                formSubmit();
                Navigator.of(context).pop(true);
              },
              child: const Text("Да"),
            ),
          ],
        );
      },
    );
  }

  void formSubmit() {
    _formKey.currentState?.save();
    // GroupRepository.db.insertGroup(
    //   GroupDB(
    //     id: _groupId,
    //     groupName: _groupName.text,
    //     groupTimes: _groupTime.text,
    //     groupDays: _groupDays!,
    //     groupPrice: int.parse(_groupPrice.text),
    //   ),
    // );
    BlocProvider.of<GroupBloc>(context).add(
      GroupEventAddAndUpdate(
        GroupDB(
          id: _groupId,
          groupName: _groupName.text,
          groupTimes: _groupTime.text,
          groupDays: _groupDays!,
          groupPrice: int.parse(_groupPrice.text),
        ),
      ),
    );
    // BlocProvider.of<GroupBloc>(context).add(GroupEventLoad());

    if (_groupId != null) {
      Navigator.of(context).pop(true);
      showSnackInfoBar(context, 'Данные обновлены');
    } else {
      showSnackInfoBar(context, 'Данные сохранены');
    }
  }
}
