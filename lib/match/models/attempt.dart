import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

class Attempt extends FormzInput<int, String> with EquatableMixin {
  const Attempt.pure({required this.maxValue})
      : isCheckedValue = false,
        super.pure(1);
  const Attempt.dirty(
      {required int value,
      required this.maxValue,
      required this.isCheckedValue})
      : super.dirty(value);

  final int maxValue;
  final bool isCheckedValue;

  @override
  String? validator(int value) {
    if (isCheckedValue) return 'Число уже проверено';
    if (value == 0 || value.isNegative) return 'Число не может быть меньше 1';
    if (value >= maxValue) return 'Число не может быть больше или равно $maxValue';
    return null;
  }

  @override
  List<Object?> get props => [value, maxValue, isCheckedValue, error];

  @override
  String toString() {
    return 'Attempt{value: $value, maxValue: $maxValue, isCheckedValue: $isCheckedValue, error: $error}';
  }
}
