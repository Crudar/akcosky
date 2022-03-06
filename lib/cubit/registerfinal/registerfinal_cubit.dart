import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:conduit_password_hash/pbkdf2.dart';
import 'package:conduit_password_hash/salt.dart';
import '../../resources/RegisterRepository.dart';

part 'registerfinal_state.dart';

class RegisterFinalCubit extends Cubit<RegisterFinalState> {
  RegisterFinalCubit() : super(RegisterFinalInitial());

  RegisterRepository registerRepository = RegisterRepository();

  Future<void> register() async {
    // TODO - check if username is available - scan with username (call to dabatase) - najlepsie by bolo keby su tie formy jednotne a ukaze to pod tym fieldom
    // TODO - check if email is not used - scan with email (call to dabatase) - najlepsie by bolo keby su tie formy jednotne a ukaze to pod tym fieldom
    emit(RegisterFinalLoading());

    var uuid = const Uuid();
    var id_ = uuid.v4();

    var generator = PBKDF2();
    var passSalt_ = Salt.generateAsBase64String(24);

    var passHash_ = generator.generateBase64Key(
        registerRepository.password, passSalt_, 10101, 24);

    bool response = await registerRepository.addUser(id_, registerRepository.login, registerRepository.email, passHash_, passSalt_);

    if (response)
      emit(RegisterFinalSuccess());
    else {
      emit(RegisterFinalError("Nemožno vytvoriť užívateľa. Si pripojený na internet?"));
    }
  }

  void checkVerificationCode(String verificationCodeInput) {
    if (verificationCodeInput == registerRepository.verificationCode) {
      register();
    }
    else {
      emit(RegisterFinalError("Chybný verifikačný kód. Skontroluj či si ho zadal správne."));
    }
  }
}
