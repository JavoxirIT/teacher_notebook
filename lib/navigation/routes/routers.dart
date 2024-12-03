import 'package:TeamLead/constants/route_name/route_name.dart';
import 'package:TeamLead/screen/add_students_screen.dart';
import 'package:TeamLead/screen/home_screen.dart';
import 'package:TeamLead/screen/payments_screen.dart';
import 'package:TeamLead/screen/setting_view.dart';
import 'package:TeamLead/screen/students_local_db_data.dart';
import 'package:TeamLead/screen/students_screen.dart';
import 'package:TeamLead/widgets/form/group_add_and_update_form.dart';
import 'package:TeamLead/widgets/form/student_update_form.dart';
import 'package:TeamLead/widgets/view/one_grop_list.dart';
import 'package:TeamLead/widgets/view/one_students_view.dart';
import 'package:TeamLead/widgets/view/pay_%20and_add_pay_one_student.dart';

final routers = {
  RouteName.homeScreen: (_) => const HomeScreen(),
  RouteName.studentsScreen: (_) => const StudentsScreen(),
  RouteName.addStudentsScreen: (_) => const AddStudentsScreen(),
  RouteName.oneStudentView: (_) => const OneStudentsView(),
  RouteName.localStudent: (_) => const StudentsLocalDBDatsScreen(),
  RouteName.localSudentUpdate: (_) => const StudentUpdateForm(),
  RouteName.paymentsScreen: (_) => const PaymentsScreen(),
  RouteName.payAdnPayAddView: (_) => const PayAndAddPayOneStudent(),
  RouteName.oneGroupListView: (_) => const OneGroupList(),
  RouteName.groupUpdateAddForm: (_) => const GroupAddForm(),
  RouteName.settingView: (_) => const SettingView()
};
