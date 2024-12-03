import 'package:TeamLead/bloc/group_bloc/group_bloc.dart';
import 'package:TeamLead/db/models/group_db_models.dart';
import 'package:TeamLead/navigation/drawer_menu.dart';
import 'package:TeamLead/widgets/form/group_add_and_update_form.dart';
import 'package:TeamLead/widgets/form/student_add_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddStudentsScreen extends StatefulWidget {
  const AddStudentsScreen({super.key});

  @override
  State<AddStudentsScreen> createState() => _AddStudentsScreenState();
}

class _AddStudentsScreenState extends State<AddStudentsScreen> {
  // late TabController _tabController;
  @override
  void initState() {
    BlocProvider.of<GroupBloc>(context).add(GroupEventLoad());
    super.initState();
  }

  List<GroupDB> group = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ДЕЙСТВИЯ"),
          centerTitle: true,
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(FontAwesomeIcons.userPlus, size: 14.0),
                child: Text(
                  "ДОБАВИТЬ УЧЕНИКА",
                  style: TextStyle(fontSize: 10.0),
                ),
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.layerGroup, size: 14.0),
                child: Text(
                  "ДОБАВИТЬ ГРУППУ",
                  style: TextStyle(fontSize: 10.0),
                ),
              ),
            ],
          ),
        ),
        drawer: const DrawerMenu(),
        body: BlocBuilder<GroupBloc, GroupState>(
          builder: (context, state) {
            if (state is GroupStateLoad) {
              group.clear();
              group = state.group;
            }
            // print('data: ${state}');
            return TabBarView(
              children: [
                StudentAddForm(group),
                const GroupAddForm(),
              ],
            );
          },
        ),
      ),
    );
  }
}
