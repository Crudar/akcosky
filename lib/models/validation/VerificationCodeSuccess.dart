import 'package:formz/formz.dart';

enum VerificationCodeFailureError { falseVerificationCode }

class VerificationCodeFailure extends FormzInput<bool, VerificationCodeFailureError> {
  const VerificationCodeFailure.pure([bool value = false]) : super.pure(value);
  const VerificationCodeFailure.dirty([bool value = false]) : super.dirty(value);

  @override
  VerificationCodeFailureError? validator(bool value) {
    return value == false ? null : VerificationCodeFailureError.falseVerificationCode;
  }
}