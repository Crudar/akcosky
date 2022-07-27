import 'dart:math';
import 'package:akcosky/resources/RegisterRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../Helpers/VerificationCodeSender.dart';
import '../../models/Database/UserDatabase.dart';

part 'registerstart_state.dart';

class RegisterStartCubit extends Cubit<RegisterStartState> {

  final RegisterRepository registerRepository;

  RegisterStartCubit({required this.registerRepository}) : super(RegisterStartInitial());

  Future<void> authenticate(String username_, String email_, String pass_) async {
    registerRepository.login = username_;
    registerRepository.email = email_;
    registerRepository.password = pass_;

    UserDatabase? checkUser = await checkAlreadyExistingLoginAndEmail(username_, email_);

    if(checkUser == null) {
      var rng = new Random();
      var code = rng.nextInt(900000) + 100000;
      registerRepository.verificationCode = code.toString();

      bool response = await VerificationCodeSender.Send(registerRepository.email, registerRepository.verificationCode);

      if (response)
        emit(RegisterStartAuthenticate());
      else {
        emit(RegisterStartError("message"));
      }
    }
    else{
      if(checkUser.login == registerRepository.login && checkUser.email == registerRepository.email){
        emit(RegisterStartCheckError(RegisterStartCheckErrorType.usernameAndEmail));
      }
      else if(checkUser.login == registerRepository.login) {
        emit(RegisterStartCheckError(RegisterStartCheckErrorType.username));
      }
      else{
        emit(RegisterStartCheckError(RegisterStartCheckErrorType.email));
      }
    }
  }

  Future<UserDatabase?> checkAlreadyExistingLoginAndEmail(String login, String email) async {
    UserDatabase? checkUser = await registerRepository.checkIfEmailOrUsernameAlreadyExists();

    return checkUser;
  }
}
