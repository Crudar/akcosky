import 'package:formz/formz.dart';

enum DateInputError { empty }

class DateInput extends FormzInput<bool, DateInputError> {
  const DateInput.pure([bool value = false]) : super.pure(false);
  const DateInput.dirty([bool value = false]) : super.dirty(value);

  @override
  DateInputError? validator(bool value) {
    return value == true ? null : DateInputError.empty;
  }
}