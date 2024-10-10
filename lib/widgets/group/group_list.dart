import 'package:assistant/bloc/group_bloc/group_bloc.dart';
import 'package:assistant/theme/style_constant.dart';
import 'package:assistant/widgets/group/group_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupList extends StatefulWidget {
  const GroupList({super.key});

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() {
    setState(() {
      BlocProvider.of<GroupBloc>(context).add(GroupEventLoad());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupBloc, GroupState>(
      builder: (context, state) {
        // print('state: ${state}');

        if (state is GroupNoDataState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Список групп пуст",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "добавьте группу",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
          );
        }

        if (state is GroupStateLoad) {
          return ListView.builder(
            itemCount: state.group.length,
            itemBuilder: (context, index) {
              final group = state.group[index];
              // print(state.group[index]);
              return groupCard(context, group);
            },
          );
        }

        if (state is GroupStateLoading) {
          const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.amber,
              color: colorGreen,
            ),
          );
        }
        if (state is GroupStateUpdateLoad) {
          return ListView.builder(
            itemCount: state.group.length,
            itemBuilder: (context, index) {
              final group = state.group[index];
              return groupCard(context, group);
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(backgroundColor: Colors.amber),
        );
      },
    );
  }
}
