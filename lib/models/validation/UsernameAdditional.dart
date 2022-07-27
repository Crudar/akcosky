import 'package:formz/formz.dart';

enum UsernameAdditionalError { collision }

class UsernameAdditional extends FormzInput<bool, UsernameAdditionalError> {
  const UsernameAdditional.pure([bool value = false]) : super.pure(value);
  const UsernameAdditional.dirty([bool value = false ]) : super.dirty(value);

  @override
  UsernameAdditionalError? validator(bool value) {
    if(value == true){
      return UsernameAdditionalError.collision;
    }
    else{
      return null;
    }
  }
}