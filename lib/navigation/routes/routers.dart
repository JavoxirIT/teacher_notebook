import 'package:assistant/constants/route_name/route_name.dart';
import 'package:assistant/screen/payments_screen.dart';
import 'package:assistant/widgets/form/group_add_and_update_form.dart';
import 'package:assistant/widgets/form/student_update_form.dart';
import 'package:assistant/widgets/view/one_grop_list.dart';
import 'package:assistant/widgets/view/one_students_view.dart';
import 'package:assistant/screen/add_students_screen.dart';
import 'package:assistant/screen/home_screen.dart';
import 'package:assistant/screen/students_local_db_data.dart';
import 'package:assistant/screen/students_screen.dart';
import 'package:assistant/widgets/view/pay_%20and_add_pay_one_student.dart';

final routers = {
  RouteName.homeScreen: (_) => const HomeScreen(),
  RouteName.studentsScreen: (_) => const StudentsScreen(),
  RouteName.addStudentsScreen: (_) => const AddStudentsScreen(),
  RouteName.oneStudentView: (_) => const OneStudentsView(),
  RouteName.localStudent: (_) => const StudentsLocalDBDatsScreen(),
  RouteName.localSudentUpdate: (_) => const StudentUpdateForm(),
  RouteName.paymentsScreen: (_) => const PaymentsScreen(),
  RouteName.payAdnPayAddView: (_) => const PayAndAddPayOneStudent(),
  RouteName.oneGroupListView: (_) => const OneGropList(),
  RouteName.groupUpdateAddForm: (_) => const GroupAddForm(),
};
