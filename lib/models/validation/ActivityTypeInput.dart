import 'package:formz/formz.dart';

enum ActivityTypeInputError { empty }

class ActivityTypeInput extends FormzInput<bool, ActivityTypeInputError> {
  const ActivityTypeInput.pure([bool value = false]) : super.pure(false);
  const ActivityTypeInput.dirty([bool value = false]) : super.dirty(value);

  @override
  ActivityTypeInputError? validator(bool value) {
    return value == true ? null : ActivityTypeInputError.empty;
  }
}