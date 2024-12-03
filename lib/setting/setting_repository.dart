import 'package:TeamLead/setting/setting_reposirory_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingRepository implements SettingReposiroryInterface {
  SettingRepository({required this.preferences});
  final SharedPreferences preferences;

  static const _isThemeSelectedKey = "dark_thrmr_select";

  @override
  bool isThemeSelect() {
    final isTheme = preferences.getBool(_isThemeSelectedKey);
    return isTheme ?? false;
  }

  @override
  Future<void> setThemeSelect(bool selected) async {
    await preferences.setBool(_isThemeSelectedKey, selected);
  }
}
