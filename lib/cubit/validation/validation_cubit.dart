import 'package:akcosky/models/validation/VerificationCodeInput.dart';
import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

import '../../models/validation/EmailInput.dart';
import '../../models/validation/PasswordAgainInput.dart';
import '../../models/validation/StringInput.dart';

part 'validation_state.dart';

enum ValidationElement{username, password, passwordAgain, email, verificationCode}

class ValidationCubit extends Cubit<ValidationState> {
  ValidationCubit({
    this.status = FormzStatus.pure,
    required this.inputsMap
  }) : super(ValidationInitial());

  FormzStatus status;
  Map<ValidationElement, FormzInput> inputsMap;

  void onEmailChanged(String emailInput){
    final email_ = EmailInput.dirty(emailInput);
    inputsMap[ValidationElement.email] = email_.valid ? email_ : EmailInput.pure(emailInput);
    validate();

    emit(ValidationInitial());
  }

  void onEmailUnfocused(){
    inputsMap[ValidationElement.email] = EmailInput.dirty(inputsMap[ValidationElement.email]?.value);

    validate();

    emit(ValidationInitial());
  }

  void onUsernameChanged(String usernameInput){
    final username_ = StringInput.dirty(usernameInput);
    inputsMap[ValidationElement.username] = username_.valid ? username_ : StringInput.pure(usernameInput);
    validate();

    emit(ValidationInitial());
  }

  void onUsernameUnfocused(){
    inputsMap[ValidationElement.username] = StringInput.dirty(inputsMap[ValidationElement.username]?.value);

    validate();

    emit(ValidationInitial());
  }

  void onPasswordChanged(String passwordInput){
    final password_ = StringInput.dirty(passwordInput);
    inputsMap[ValidationElement.password] = password_.valid ? password_ : StringInput.pure(passwordInput);
    validate();

    emit(ValidationInitial());
  }

  void onPasswordUnfocused(){
    inputsMap[ValidationElement.password] = StringInput.dirty(inputsMap[ValidationElement.password]?.value);

    validate();

    emit(ValidationInitial());
  }

  void onPasswordAgainChanged(String passwordAgainInput){
    final passwordAgain_ = PasswordAgainInput.dirty(password1: inputsMap[ValidationElement.password]?.value, password2: passwordAgainInput);
    inputsMap[ValidationElement.passwordAgain] = passwordAgain_; //.valid ? passwordAgain_ : PasswordAgainInput.pure(passwordAgainInput);
    validate();

    emit(ValidationInitial());
  }

  void onPasswordAgainUnfocused(){
    inputsMap[ValidationElement.passwordAgain] = PasswordAgainInput.dirty(password1: inputsMap[ValidationElement.password]?.value, password2: inputsMap[ValidationElement.passwordAgain]?.value ?? "");

    validate();

    emit(ValidationInitial());
  }

  void onVerificationCodeChanged(String verificationInput){
    final verification_ = VerificationCodeInput.dirty(verificationInput);
    inputsMap[ValidationElement.verificationCode] = verification_.valid ? verification_ : VerificationCodeInput.pure(verificationInput);
    validate();

    emit(ValidationInitial());
  }

  void onVerificationCodeUnfocused(){
    inputsMap[ValidationElement.verificationCode] = VerificationCodeInput.dirty(inputsMap[ValidationElement.verificationCode]?.value);

    validate();

    emit(ValidationInitial());
  }

  validate(){
    List<FormzInput> values = inputsMap.entries.map((e) => e.value).toList();
    status = Formz.validate(values);
  }
}
