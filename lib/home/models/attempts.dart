import 'package:formz/formz.dart';

class Attempts extends FormzInput<int, String> {
  const Attempts.pure() : super.pure(5);
  const Attempts.dirty([super.value = 5]) : super.dirty();

  @override
  String? validator(int value) {
    if (value < 1) return 'Число не может быть меньше 1';
    return null;
  }

  @override
  String toString() {
    return 'Attempts{value: $value, error: $error}';
  }
}
