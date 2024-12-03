import 'package:TeamLead/db/init_db.dart';
import 'package:TeamLead/theme/color.dart';
import 'package:TeamLead/widgets/show_cupertino_modal_popup.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<StatefulWidget> createState() => _SettingViewState();
}

class _SettingViewState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Настройки"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Удалить все данные"),
                IconButton(
                  onPressed: () {
                    showCupModalPopup(
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                "Вы уверены??",
                                style: textStyle!
                                    .copyWith(color: colorRed, fontSize: 18),
                              ),
                              const Gap(10.0),
                              Text(
                                "посдле удаления всех данных, восствновить бедет не возможно",
                                style: textStyle,
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        InitDB().deleteDatabaseFile();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Да", style: textStyle),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Нет", style: textStyle),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        context,
                        300.0);
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.trash,
                    color: coloR0xFF707B7C,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
