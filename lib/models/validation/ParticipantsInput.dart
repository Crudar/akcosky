import 'package:formz/formz.dart';

enum ParticipantsInputError { zero }

class ParticipantsInput extends FormzInput<int, ParticipantsInputError> {
  const ParticipantsInput.pure([int value = 0]) : super.pure(value);
  const ParticipantsInput.dirty([int value = 0]) : super.dirty(value);

  @override
  ParticipantsInputError? validator(int value) {
    return value != 0 ? null : ParticipantsInputError.zero;
  }
}