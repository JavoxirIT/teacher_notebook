String? validatePhoneFormatter(String input) {
  final phoneExp = RegExp(r'^\d\d\d\d\d\d\d\d\d$');
  if (input == "") {
    return "Заполните поле";
  } else if (phoneExp.hasMatch(input)) {
    return null;
  } else {
    return "Не верный формат номера";
  }
}
