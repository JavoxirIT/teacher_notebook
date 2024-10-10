import 'package:assistant/bloc/group_bloc/group_bloc.dart';
import 'package:assistant/bloc/payments_bloc/payments_bloc.dart';
import 'package:assistant/bloc/student_and_group_bloc/student_and_group_list_bloc.dart';
import 'package:assistant/bloc/student_bloc/student_bloc.dart';
import 'package:assistant/bloc/student_in_a_group_bloc/student_in_a_group_bloc.dart';
import 'package:assistant/bloc/theme_bloc/theme_bloc_bloc.dart';
import 'package:assistant/db/new_group_repository.dart';
import 'package:assistant/db/payments_repository.dart';
import 'package:assistant/db/student_add_group_repository.dart';
import 'package:assistant/db/student_repository.dart';
import 'package:assistant/navigation/routes/routers.dart';
import 'package:assistant/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StudentBloc>(
            create: (context) => StudentBloc(StudentRepository.db)),
        BlocProvider<ThemeBlocBloc>(create: (context) => ThemeBlocBloc()),
        BlocProvider<PaymentsBloc>(
            create: (context) => PaymentsBloc(PaysRepository.db)),
        BlocProvider(create: (context) => GroupBloc(NewGroupRepository.db)),
        BlocProvider(
            create: (context) =>
                StudentAndGroupListBloc(StudentAddGroupRepository.db)),
        BlocProvider(
            create: (context) =>
                StudentInAGroupBloc(StudentAddGroupRepository.db)),
      ],
      child: const AppTheme(),
    );
  }
}

class AppTheme extends StatefulWidget {
  const AppTheme({
    super.key,
  });

  @override
  State<AppTheme> createState() => _AppThemeState();
}

class _AppThemeState extends State<AppTheme> {
  @override
  void initState() {
    BlocProvider.of<ThemeBlocBloc>(context).add(ThemeInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBlocBloc, ThemeBlocState>(
      builder: (context, state) {
        if (state is ThemeAddState) {
          return MaterialApp(
            home: const SplashScreen(),
            theme: state.theme,
            routes: routers,
          );
        }
        return const SizedBox();
      },
    );
  }
}
