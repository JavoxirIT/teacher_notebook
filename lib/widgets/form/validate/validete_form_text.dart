String? valideteText(String input) {
  final textExp = RegExp(r'^[a-zA-Z-А-Яа-я\s]+$');
  if (input.isEmpty) {
    return "Заполните поле";
  } else if (!textExp.hasMatch(input)) {
    return "Введите буквенные значения";
  } else {
    return null;
  }
}
