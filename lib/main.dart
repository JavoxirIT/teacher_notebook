import 'dart:developer';

import 'package:TeamLead/screen/home_screen.dart';
import 'package:TeamLead/theme/dark_theme.dart';
import 'package:TeamLead/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/group_bloc/group_bloc.dart';
import 'bloc/payments_bloc/payments_bloc.dart';
import 'bloc/student_and_group_bloc/student_and_group_list_bloc.dart';
import 'bloc/student_bloc/student_bloc.dart';
import 'bloc/student_in_a_group_bloc/student_in_a_group_bloc.dart';
import 'bloc/theme/theme_cubit.dart';
import 'db/new_group_repository.dart';
import 'db/payments_repository.dart';
import 'db/student_add_group_repository.dart';
import 'db/student_repository.dart';
import 'navigation/routes/routers.dart';
import 'setting/setting_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    runApp(MyApp(preferences: prefs));
  } catch (e) {
    log('SharedPreferences ERROR $e');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.preferences});

  final SharedPreferences preferences;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final settingRepository =
        SettingRepository(preferences: widget.preferences);
    return MultiBlocProvider(
      providers: [
        BlocProvider<StudentBloc>(
            create: (context) => StudentBloc(StudentRepository.db)),
        BlocProvider<PaymentsBloc>(
            create: (context) => PaymentsBloc(PaysRepository.db)),
        BlocProvider(create: (context) => GroupBloc(NewGroupRepository.db)),
        BlocProvider(
            create: (context) =>
                StudentAndGroupListBloc(StudentAddGroupRepository.db)),
        BlocProvider(
            create: (context) =>
                StudentInAGroupBloc(StudentAddGroupRepository.db)),
        BlocProvider(
            create: (context) =>
                ThemeCubit(settingRepository: settingRepository)),
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
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          home: const HomeScreen(),
          theme: state.isTheme ? darkTheme : lightTheme,
          routes: routers,
        );
      },
    );
  }
}
