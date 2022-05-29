import 'package:akcosky/models/validation/StringInput.dart';
import 'package:formz/formz.dart';

enum PasswordAgainInputError { invalid, mismatch }

class PasswordAgainInput extends FormzInput<String, PasswordAgainInputError> {
  final String password1;

  const PasswordAgainInput.pure(this.password1) : super.pure(password1);
  const PasswordAgainInput.dirty({required this.password1, String password2 = ''}) : super.dirty(password2);

  @override
  PasswordAgainInputError? validator(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return PasswordAgainInputError.invalid;
      }
    }
    return password1 == value
        ? null
        : PasswordAgainInputError.mismatch;
  }
}