import 'dart:math';

import 'package:akcosky/models/User.dart';
import 'package:akcosky/resources/Database.dart';
import 'package:akcosky/resources/RegisterRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:conduit_password_hash/pbkdf2.dart';
import 'package:conduit_password_hash/salt.dart';
import '../../Helpers/VerificationCodeSender.dart';

part 'registerstart_state.dart';

class RegisterStartCubit extends Cubit<RegisterStartState> {
  RegisterStartCubit() : super(RegisterStartInitial());

  Future<void> authenticate(String username_, String email_, String pass_) async {
    RegisterRepository registerRepository = RegisterRepository();

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
