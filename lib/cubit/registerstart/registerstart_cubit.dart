import 'dart:math';
import 'package:akcosky/resources/RegisterRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../Helpers/VerificationCodeSender.dart';

part 'registerstart_state.dart';

class RegisterStartCubit extends Cubit<RegisterStartState> {
  final RegisterRepository _registerRepository;

  RegisterStartCubit(this._registerRepository) : super(RegisterStartInitial());

  Future<void> authenticate(String username_, String email_, String pass_) async {
    _registerRepository.login = username_;
    _registerRepository.email = email_;
    _registerRepository.password = pass_;

    var rng = new Random();
    var code = rng.nextInt(900000) + 100000;
    _registerRepository.verificationCode = code.toString();

    bool response = await VerificationCodeSender.Send(_registerRepository.email, _registerRepository.verificationCode);

    if(response)
      emit(RegisterStartAuthenticate());
    else{
      emit(RegisterStartError("message"));
    }
  }
}
