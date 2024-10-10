String? validateEmail(String input) {
  if (input.isEmpty) {
    return "Заполните поле Email";
  } else if (input.contains("@")) {
    return "не валидный tmail";
  } else {
    return null;
  }
}
