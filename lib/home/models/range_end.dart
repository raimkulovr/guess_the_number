import 'package:formz/formz.dart';
import 'dart:math';

enum RangeEndValidationError { zero, negative, one }

class RangeEnd extends FormzInput<int, String> {
  const RangeEnd.pure() : super.pure(10);
  const RangeEnd.dirty([super.value = 10]) : super.dirty();

  @override
  String? validator(int value) {
    if (value < 3) return 'Число не может быть меньше 3';
    if (value > pow(2, 32)) return 'Число не может быть больше 2^32';
    return null;
  }

  @override
  String toString() {
    return 'RangeEnd{value: $value, error: $error}';
  }
}
