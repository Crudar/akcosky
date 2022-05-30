import 'dart:math';
import 'package:akcosky/models/validation/EmailInput.dart';
import 'package:akcosky/models/validation/StringInput.dart';
import 'package:akcosky/resources/RegisterRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';
import '../../Helpers/VerificationCodeSender.dart';
import '../../models/validation/PasswordAgainInput.dart';

part 'registerstart_state.dart';

class RegisterStartCubit extends Cubit<RegisterStartState> {
   /*EmailInput email;
   StringInput username;
   StringInput password;
   PasswordAgainInput passwordAgain;
   FormzStatus status;*/

  final RegisterRepository registerRepository;

  RegisterStartCubit({required this.registerRepository,
  /*this.email = const EmailInput.pure(),
  this.username = const StringInput.pure(),
  this.password = const StringInput.pure(),
  this.passwordAgain = const PasswordAgainInput.pure(""),
  this.status = FormzStatus.pure*/}) : super(RegisterStartInitial());

  /*void onEmailChanged(String emailInput){
    final email_ = EmailInput.dirty(emailInput);
    email = email_.valid ? email_ : EmailInput.pure(emailInput);
    status = Formz.validate([email, username, password , passwordAgain]);

    emit(RegisterStartInitial());
  }

   void onEmailUnfocused(){
     email = EmailInput.dirty(email.value);

     status = Formz.validate([email, username, password , passwordAgain]);

     emit(RegisterStartInitial());
   }

   void onUsernameChanged(String usernameInput){
     final username_ = StringInput.dirty(usernameInput);
     username = username_.valid ? username_ : StringInput.pure(usernameInput);
     status = Formz.validate([email, username, password , passwordAgain]);

     emit(RegisterStartInitial());
   }

   void onUsernameUnfocused(){
    username = StringInput.dirty(username.value);

     status = Formz.validate([email, username, password , passwordAgain]);

     emit(RegisterStartInitial());
   }

   void onPasswordChanged(String passwordInput){
     final password_ = StringInput.dirty(passwordInput);
     password = password_.valid ? password_ : StringInput.pure(passwordInput);
     status = Formz.validate([email, username, password , passwordAgain]);

     emit(RegisterStartInitial());
   }

   void onPasswordUnfocused(){
    password = StringInput.dirty(password.value);

     status = Formz.validate([email, username, password , passwordAgain]);

     emit(RegisterStartInitial());
   }

   void onPasswordAgainChanged(String passwordAgainInput){
     final passwordAgain_ = PasswordAgainInput.dirty(password1: password.value, password2: passwordAgainInput);
     passwordAgain = passwordAgain_.valid ? passwordAgain_ : PasswordAgainInput.pure(passwordAgainInput);
     status = Formz.validate([email, username, password , passwordAgain]);

     emit(RegisterStartInitial());
   }

   void onPasswordAgainUnfocused(){
     passwordAgain = PasswordAgainInput.dirty(password1: password.value, password2: passwordAgain.value);

     status = Formz.validate([email, username, password , passwordAgain]);

     emit(RegisterStartInitial());
   }*/

  Future<void> authenticate(String username_, String email_, String pass_) async {
    registerRepository.login = username_;
    registerRepository.email = email_;
    registerRepository.password = pass_;

    var rng = new Random();
    var code = rng.nextInt(900000) + 100000;
    registerRepository.verificationCode = code.toString();

    bool response = await VerificationCodeSender.Send(registerRepository.email, registerRepository.verificationCode);

    if(response)
      emit(RegisterStartAuthenticate());
    else{
      emit(RegisterStartError("message"));
    }
  }
}
