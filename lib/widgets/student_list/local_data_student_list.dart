import 'package:assistant/bloc/student_bloc/student_bloc.dart';
import 'package:assistant/widgets/student_list/components/student_list_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalDataStudentList extends StatefulWidget {
  const LocalDataStudentList({super.key});

  @override
  State<LocalDataStudentList> createState() => _LocalDataStudentListState();
}

class _LocalDataStudentListState extends State<LocalDataStudentList> {
  @override
  void initState() {
    BlocProvider.of<StudentBloc>(context).add(StudentEventLoad());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StudentBloc, StudentState>(
        builder: (context, state) {
          if (state is StudentSearchNoDataState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Такого ученика в данных нет",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      "Пожалуйста введите существующий имя",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is StudentLoadedState) {
            return ListView.builder(
              itemCount: state.loadedStudent.length,
              itemBuilder: (context, i) {
                final item = state.loadedStudent[i];
                return studentListData(context, item);
              },
            );
          }
          if (state is StudentNoDataState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Список учиников пуст",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      "Пожалуйста добавьте учиника",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
