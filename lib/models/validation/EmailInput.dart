import 'package:formz/formz.dart';

enum EmailInputError { invalid }

class EmailInput extends FormzInput<String, EmailInputError> {
  const EmailInput.pure([String value = '']) : super.pure(value);
  const EmailInput.dirty([String value = '']) : super.dirty(value);

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  EmailInputError? validator(String? value) {
    return _emailRegex.hasMatch(value ?? '')
        ? null
        : EmailInputError.invalid;
  }
}