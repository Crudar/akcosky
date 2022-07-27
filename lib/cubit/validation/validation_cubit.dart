import 'package:akcosky/models/validation/ActivityTypeInput.dart';
import 'package:akcosky/models/validation/DateInput.dart';
import 'package:akcosky/models/validation/EmailAdditional.dart';
import 'package:akcosky/models/validation/ParticipantsInput.dart';
import 'package:akcosky/models/validation/NonAuthenticated.dart';
import 'package:akcosky/models/validation/VerificationCodeInput.dart';
import 'package:akcosky/models/validation/VerificationCodeSuccess.dart';
import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

import '../../models/validation/EmailInput.dart';
import '../../models/validation/PasswordAgainInput.dart';
import '../../models/validation/StringInput.dart';
import '../../models/validation/UsernameAdditional.dart';

part 'validation_state.dart';

enum ValidationElement{username, password, passwordAgain, nonauthenticated, email, verificationCode, title, description, place, date,
  activityType, participants, verificationCodeFailure, usernameAdditional, emailAdditional}

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

    checkEmailAdditional();

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

    checkUsernameAdditional();

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

    checkNonAuthenticated();

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

  void onNonAuthenticated(){
    final nonauthenticated_ = NonAuthenticated.dirty(true);
    inputsMap[ValidationElement.nonauthenticated] = nonauthenticated_.valid ? nonauthenticated_ : NonAuthenticated.dirty(true);
    validate();

    emit(ValidationInitial());
  }

  void checkNonAuthenticated(){
    FormzInput? value = inputsMap[ValidationElement.nonauthenticated];

    if(value != null){
      if(value.invalid){
        inputsMap[ValidationElement.nonauthenticated] = NonAuthenticated.dirty(false);
      }
    }
  }

  void onVerificationCodeChanged(String verificationInput){
    final verification_ = VerificationCodeInput.dirty(verificationInput);
    inputsMap[ValidationElement.verificationCode] = verification_.valid ? verification_ : VerificationCodeInput.pure(verificationInput);

    checkVerificationCodeFailure();

    validate();

    emit(ValidationInitial());
  }

  void onVerificationCodeUnfocused(){
    inputsMap[ValidationElement.verificationCode] = VerificationCodeInput.dirty(inputsMap[ValidationElement.verificationCode]?.value);

    validate();

    emit(ValidationInitial());
  }

  void onDateClicked(){
    final date_ = DateInput.dirty(true);
    inputsMap[ValidationElement.date] = date_.valid ? date_ : DateInput.pure(true);
    validate();

    emit(ValidationInitial());
  }

  void onDateUnClicked(){
    final date_ = DateInput.dirty(false);
    inputsMap[ValidationElement.date] = date_.valid ? date_ : DateInput.pure(false);
    validate();

    emit(ValidationInitial());
  }

  void onDateUnfocused(){
    inputsMap[ValidationElement.date] = DateInput.dirty(inputsMap[ValidationElement.date]?.value);

    validate();

    emit(ValidationInitial());
  }

  void onActivityTypeClicked(){
    final activityType_ = ActivityTypeInput.dirty(true);
    inputsMap[ValidationElement.activityType] = activityType_.valid ? activityType_ : ActivityTypeInput.pure(true);
    validate();

    emit(ValidationInitial());
  }

  void onActivityTypeUnfocused(){
    inputsMap[ValidationElement.activityType] = VerificationCodeInput.dirty(inputsMap[ValidationElement.activityType]?.value);

    validate();

    emit(ValidationInitial());
  }

  void onNewEventInputChanged(String input, ValidationElement element){
    final newEventInput = StringInput.dirty(input);
    inputsMap[element] = newEventInput.valid ? newEventInput : StringInput.pure(input);
    validate();

    emit(ValidationInitial());
  }

  void onNewEventInputUnfocused(ValidationElement element){
    inputsMap[element] = StringInput.dirty(inputsMap[element]?.value);

    validate();

    emit(ValidationInitial());
  }

  void onParticipantClicked(int clickedCount){
    final participant = ParticipantsInput.dirty(clickedCount);
    inputsMap[ValidationElement.participants] = participant.valid ? participant : ParticipantsInput.pure(clickedCount);
    validate();

    emit(ValidationInitial());
  }

  void onVerificationCodeFailure(){
    final verificationcodefailure = VerificationCodeFailure.dirty(true);
    inputsMap[ValidationElement.verificationCodeFailure] = verificationcodefailure.valid ? verificationcodefailure : VerificationCodeFailure.dirty(true);
    validate();

    emit(ValidationInitial());
  }

  void checkVerificationCodeFailure(){
    FormzInput? value = inputsMap[ValidationElement.verificationCodeFailure];

    if(value != null){
      if(value.invalid){
        inputsMap[ValidationElement.verificationCodeFailure] = VerificationCodeFailure.dirty(false);
      }
    }
  }

  void onUsernameAdditional(){
    final registerCollision = UsernameAdditional.dirty(true);
    inputsMap[ValidationElement.usernameAdditional] = registerCollision.valid ? registerCollision : UsernameAdditional.dirty(true);
    validate();

    emit(ValidationInitial());
  }

  void checkUsernameAdditional(){
    FormzInput? value = inputsMap[ValidationElement.usernameAdditional];

    if(value != null){
      if(value.invalid){
        inputsMap[ValidationElement.usernameAdditional] = UsernameAdditional.dirty(false);
      }
    }
  }

  void onEmailAdditional(){
    final emailAdditional = EmailAdditional.dirty(true);
    inputsMap[ValidationElement.emailAdditional] = emailAdditional.valid ? emailAdditional : EmailAdditional.dirty(true);
    validate();

    emit(ValidationInitial());
  }

  void checkEmailAdditional(){
    FormzInput? value = inputsMap[ValidationElement.emailAdditional];

    if(value != null){
      if(value.invalid){
        inputsMap[ValidationElement.emailAdditional] = EmailAdditional.dirty(false);
      }
    }
  }

  void addInput(ValidationElement element, FormzInput input){
    inputsMap[element] = input;

    validate();
    emit(ValidationInitial());
  }

  void removeInput(ValidationElement element){
    inputsMap.remove(element);

    validate();
    emit(ValidationInitial());
  }

  validate(){
    List<FormzInput> values = inputsMap.entries.map((e) => e.value).toList();
    status = Formz.validate(values);
  }
}
