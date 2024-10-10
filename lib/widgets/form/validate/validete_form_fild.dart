String? validate(value) {
  if (value == null || value.isEmpty) {
    return 'Заполните поле';
  }
  return null;
}
