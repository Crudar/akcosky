import 'package:formz/formz.dart';

enum VerificationCodeInputError { empty, wrongDigitCount, isString}

class VerificationCodeInput extends FormzInput<String, VerificationCodeInputError> {
  const VerificationCodeInput.pure([String value = '']) : super.pure(value);
  const VerificationCodeInput.dirty([String value = '']) : super.dirty(value);

  @override
  VerificationCodeInputError? validator(String value) {
    if(value.isEmpty){
      return VerificationCodeInputError.empty;
    }
    else if(int.tryParse(value) == null){
      return VerificationCodeInputError.isString;
    }
    else if(value.length != 6){
      return VerificationCodeInputError.wrongDigitCount;
    }
    else{
      return null;
    }
  }
}