import 'package:formz/formz.dart';

enum StringInputError { empty }

class StringInput extends FormzInput<String, StringInputError> {
  const StringInput.pure([String value = '']) : super.pure('');
  const StringInput.dirty([String value = '']) : super.dirty(value);

  @override
  StringInputError? validator(String value) {
    return value.isNotEmpty == true ? null : StringInputError.empty;
  }
}