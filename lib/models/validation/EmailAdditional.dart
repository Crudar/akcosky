import 'package:formz/formz.dart';

enum EmailAdditionalError { collision }

class EmailAdditional extends FormzInput<bool, EmailAdditionalError> {
  const EmailAdditional.pure([bool collision = false]) : super.pure(collision);
  const EmailAdditional.dirty([bool collision = false]) : super.dirty(collision);

  @override
  EmailAdditionalError? validator(bool value) {
    if(value == true) {
      return EmailAdditionalError.collision;
    }
    else{
      return null;
    }
  }
}