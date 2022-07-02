import 'package:formz/formz.dart';

enum NonAuthenticatedError { nonauthenticated }

class NonAuthenticated extends FormzInput<bool, NonAuthenticatedError> {
  const NonAuthenticated.pure([bool value = false]) : super.pure(value);
  const NonAuthenticated.dirty([bool value = false]) : super.dirty(value);

  @override
  NonAuthenticatedError? validator(bool value) {
    return value == false ? null : NonAuthenticatedError.nonauthenticated;
  }
}